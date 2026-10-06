import Crypto
import Fluent
import Vapor

struct GoogleLogin: Content { let idToken: String }
struct SessionResponse: Content {
    let userID: UUID
    let token: String
    let expiresAt: Double
}
struct UserResponse: Content { let userID: UUID }
struct FavoriteResponse: Content { let characterID: Int }

func tokenHash(_ token: String) -> String {
    SHA256.hash(data: Data(token.utf8)).map { String(format: "%02x", $0) }.joined()
}

struct SessionAuthenticator: AsyncBearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        guard bearer.token.utf8.count == 64 else { return }
        guard
            let session = try await UserSession.query(on: request.db)
                .filter(\.$tokenHash == tokenHash(bearer.token))
                .filter(\.$expiresAt > Date()).first()
        else { return }
        request.auth.login(try await session.$user.get(on: request.db))
    }
}

func routes(
    _ app: Application, googleClientID: String,
    verifier: any GoogleIdentityVerifying = GoogleIdentityVerifier()
) throws {
    app.get("health") { _ in ["status": "ok"] }
    let api = app.grouped("v1")
    api.post("auth", "google") { req async throws -> SessionResponse in
        let body = try req.content.decode(GoogleLogin.self)
        guard !body.idToken.isEmpty, body.idToken.utf8.count <= 8192 else { throw Abort(.badRequest) }
        let subject: String
        do {
            subject = try await verifier.verify(body.idToken, clientID: googleClientID, client: req.client)
        } catch let error as AbortError where error.status == .serviceUnavailable {
            throw error
        } catch { throw Abort(.unauthorized, reason: "Credenciales de Google no válidas.") }
        let user: User
        if let existing = try await User.query(on: req.db).filter(\.$googleSubject == subject).first() {
            user = existing
        } else {
            let created = User(subject: subject)
            do {
                try await created.create(on: req.db)
                user = created
            } catch {
                guard
                    let existing = try await User.query(on: req.db).filter(\.$googleSubject == subject)
                        .first()
                else { throw error }
                user = existing
            }
        }
        let userID = try user.requireID()
        // Limpieza acotada a esta cuenta; no se requiere un servicio programado de pago.
        try await UserSession.query(on: req.db).filter(\.$user.$id == userID)
            .filter(\.$expiresAt <= Date()).delete()
        var rng = SystemRandomNumberGenerator()
        let token = (0..<32).map { _ in String(format: "%02x", UInt8.random(in: .min ... .max, using: &rng)) }
            .joined()
        let expiration = Date().addingTimeInterval(7 * 24 * 3600)
        try await UserSession(userID: userID, hash: tokenHash(token), expiresAt: expiration).create(
            on: req.db)
        return SessionResponse(userID: userID, token: token, expiresAt: expiration.timeIntervalSince1970)
    }
    let secured = api.grouped(SessionAuthenticator(), User.guardMiddleware())
    secured.get("me") { req async throws -> UserResponse in
        UserResponse(userID: try req.auth.require(User.self).requireID())
    }
    secured.delete("auth", "session") { req async throws -> HTTPStatus in
        let userID = try req.auth.require(User.self).requireID()
        guard let bearer = req.headers.bearerAuthorization else { throw Abort(.unauthorized) }
        try await UserSession.query(on: req.db).filter(\.$user.$id == userID)
            .filter(\.$tokenHash == tokenHash(bearer.token)).delete()
        return .noContent
    }
    secured.get("favorites") { req async throws -> [FavoriteResponse] in
        let userID = try req.auth.require(User.self).requireID()
        return try await Favorite.query(on: req.db).filter(\.$user.$id == userID)
            .sort(\.$characterID).all().map { FavoriteResponse(characterID: $0.characterID) }
    }
    secured.put("favorites", ":characterID") { req async throws -> HTTPStatus in
        let userID = try req.auth.require(User.self).requireID()
        let id = try characterID(req)
        if try await Favorite.query(on: req.db).filter(\.$user.$id == userID).filter(\.$characterID == id)
            .first() == nil
        {
            do { try await Favorite(userID: userID, characterID: id).create(on: req.db) } catch {
                guard
                    try await Favorite.query(on: req.db).filter(\.$user.$id == userID).filter(
                        \.$characterID == id
                    ).first() != nil
                else { throw error }
            }
        }
        return .noContent
    }
    secured.delete("favorites", ":characterID") { req async throws -> HTTPStatus in
        let userID = try req.auth.require(User.self).requireID()
        let id = try characterID(req)
        try await Favorite.query(on: req.db).filter(\.$user.$id == userID).filter(\.$characterID == id)
            .delete()
        return .noContent
    }
}

private func characterID(_ req: Request) throws -> Int {
    guard let id = req.parameters.get("characterID", as: Int.self), (1...1_000_000).contains(id) else {
        throw Abort(.badRequest, reason: "Identificador de personaje no válido.")
    }
    return id
}
