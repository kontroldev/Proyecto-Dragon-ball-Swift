import FluentSQLiteDriver
import JWTKit
import XCTVapor

@testable import App

final class BackendTests: XCTestCase {
    func testFavoritesIsolationAndSessionRevocation() async throws {
        let app = try await Application.make(.testing)
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(CreateSchema())
        try await app.autoMigrate()
        try routes(app, googleClientID: "test-client")
        do {
            let first = User(subject: "google-a")
            let second = User(subject: "google-b")
            try await first.create(on: app.db)
            try await second.create(on: app.db)
            let tokenA = String(repeating: "a", count: 64)
            let tokenB = String(repeating: "b", count: 64)
            try await UserSession(
                userID: first.requireID(), hash: tokenHash(tokenA), expiresAt: Date().addingTimeInterval(3600)
            ).create(on: app.db)
            try await UserSession(
                userID: second.requireID(), hash: tokenHash(tokenB),
                expiresAt: Date().addingTimeInterval(3600)
            ).create(on: app.db)
            let headerA = HTTPHeaders([("Authorization", "Bearer \(tokenA)")])
            let headerB = HTTPHeaders([("Authorization", "Bearer \(tokenB)")])
            try await app.test(.GET, "v1/favorites") { res async throws in
                XCTAssertEqual(res.status, .unauthorized)
            }
            try await app.test(.PUT, "v1/favorites/7", headers: headerA) { res async throws in
                XCTAssertEqual(res.status, .noContent)
            }
            try await app.test(.PUT, "v1/favorites/7", headers: headerA) { res async throws in
                XCTAssertEqual(res.status, .noContent)
            }
            let count = try await Favorite.query(on: app.db).count()
            XCTAssertEqual(count, 1)
            try await app.test(.GET, "v1/favorites", headers: headerB) { res async throws in
                XCTAssertEqual(try res.content.decode([FavoriteResponse].self).count, 0)
            }
            try await app.test(.DELETE, "v1/favorites/7", headers: headerB) { res async throws in
                XCTAssertEqual(res.status, .noContent)
            }
            try await app.test(.GET, "v1/favorites", headers: headerA) { res async throws in
                XCTAssertEqual(try res.content.decode([FavoriteResponse].self).map(\.characterID), [7])
            }
            try await app.test(.PUT, "v1/favorites/-1", headers: headerA) { res async throws in
                XCTAssertEqual(res.status, .badRequest)
            }
            try await app.test(.DELETE, "v1/auth/session", headers: headerA) { res async throws in
                XCTAssertEqual(res.status, .noContent)
            }
            try await app.test(.GET, "v1/favorites", headers: headerA) { res async throws in
                XCTAssertEqual(res.status, .unauthorized)
            }
            try await app.test(.GET, "v1/favorites", headers: headerB) { res async throws in
                XCTAssertEqual(res.status, .ok)
            }
            let expired = String(repeating: "c", count: 64)
            try await UserSession(
                userID: first.requireID(), hash: tokenHash(expired), expiresAt: .distantPast
            ).create(on: app.db)
            try await app.test(.GET, "v1/me", headers: HTTPHeaders([("Authorization", "Bearer \(expired)")]))
            { res async throws in XCTAssertEqual(res.status, .unauthorized) }
            try await app.test(
                .POST, "v1/auth/google",
                beforeRequest: { req async throws in
                    try req.content.encode(GoogleLogin(idToken: ""))
                }, afterResponse: { res async throws in XCTAssertEqual(res.status, .badRequest) })
            try await app.asyncShutdown()
        } catch {
            try await app.asyncShutdown()
            throw error
        }
    }

    func testLoginCreatesAndReusesUser() async throws {
        let app = try await Application.make(.testing)
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(CreateSchema())
        try await app.autoMigrate()
        try routes(app, googleClientID: "test-client", verifier: VerifiedGoogleStub())
        do {
            for _ in 0..<2 {
                try await app.test(
                    .POST, "v1/auth/google",
                    beforeRequest: { req async throws in
                        try req.content.encode(GoogleLogin(idToken: "verified-by-stub"))
                    },
                    afterResponse: { res async throws in
                        XCTAssertEqual(res.status, .ok)
                        let session = try res.content.decode(SessionResponse.self)
                        XCTAssertEqual(session.token.utf8.count, 64)
                        XCTAssertGreaterThan(session.expiresAt, Date().timeIntervalSince1970)
                        let stored = try await UserSession.query(on: app.db)
                            .filter(\.$tokenHash == tokenHash(session.token)).first()
                        XCTAssertNotNil(stored)
                        XCTAssertNotEqual(stored?.tokenHash, session.token)
                        try await app.test(
                            .GET, "v1/me",
                            headers: HTTPHeaders([
                                ("Authorization", "Bearer \(session.token)")
                            ])
                        ) { res async throws in
                            XCTAssertEqual(try res.content.decode(UserResponse.self).userID, session.userID)
                        }
                    })
            }
            let count = try await User.query(on: app.db).count()
            XCTAssertEqual(count, 1)
            try await app.asyncShutdown()
        } catch {
            try await app.asyncShutdown()
            throw error
        }
    }

    func testGoogleClaimsAndTampering() async throws {
        let keys = JWTKeyCollection()
        await keys.add(hmac: "test-only-key-not-used-in-server", digestAlgorithm: .sha256)
        let valid = GoogleIdentity(
            sub: "subject", iss: "https://accounts.google.com", aud: .init(value: ["client"]),
            exp: .init(value: Date().addingTimeInterval(300)))
        let token = try await keys.sign(valid)
        let verified = try await keys.verify(token, as: GoogleIdentity.self)
        try verified.aud.verifyIntendedAudience(includes: "client")
        XCTAssertThrowsError(try verified.aud.verifyIntendedAudience(includes: "another-client"))
        for identity in [
            GoogleIdentity(sub: "subject", iss: "attacker", aud: valid.aud, exp: valid.exp),
            GoogleIdentity(sub: "subject", iss: valid.iss, aud: valid.aud, exp: .init(value: .distantPast)),
        ] {
            let invalid = try await keys.sign(identity)
            do {
                _ = try await keys.verify(invalid, as: GoogleIdentity.self)
                XCTFail("Claims inválidas aceptadas")
            } catch {}
        }
        do {
            _ = try await keys.verify(token + "tampered", as: GoogleIdentity.self)
            XCTFail("Firma inválida aceptada")
        } catch {}
    }
}

private struct VerifiedGoogleStub: GoogleIdentityVerifying {
    func verify(_ token: String, clientID: String, client: any Client) async throws -> String {
        guard token == "verified-by-stub", clientID == "test-client" else { throw Abort(.unauthorized) }
        return "verified-google-subject"
    }
}
