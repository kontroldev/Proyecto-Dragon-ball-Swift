import CardRules
import FluentSQLiteDriver
import XCTVapor
@testable import App

final class CardRoomTests: XCTestCase {
    func testRoomRequiresAuthenticationAndHidesOtherHands() async throws {
        let app = try await Application.make(.testing)
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(CreateSchema()); app.migrations.add(CreateCardRooms())
        try await app.autoMigrate()
        cardRoomRoutes(app)
        do {
            let users = (0..<4).map { User(subject: "cards-test-\($0)") }
            for user in users { try await user.create(on: app.db) }
            let token = String(repeating: "a", count: 64)
            try await UserSession(userID: users[0].requireID(), hash: tokenHash(token), expiresAt: Date().addingTimeInterval(3600)).create(on: app.db)
            let header = HTTPHeaders([("Authorization", "Bearer \(token)")])
            try await app.test(.POST, "v1/rooms") { response async throws in
                XCTAssertEqual(response.status, .unauthorized)
            }
            try await app.test(.POST, "v1/rooms", headers: header) { response async throws in
                XCTAssertEqual(response.status, .ok)
                let state = try response.content.decode(CardRoomState.self)
                XCTAssertEqual(state.players, 1); XCTAssertTrue(state.hand.isEmpty)
            }
            let game = BattleGame()
            let room = try CardRoom(code: "ABCDEF1234", user: users[0].requireID())
            room.payload = try JSONEncoder().encode(RoomPayload(members: try users.map { try $0.requireID() }, game: game, version: 1))
            try await room.create(on: app.db)
            try await app.test(.GET, "v1/rooms/ABCDEF1234", headers: header) { response async throws in
                XCTAssertEqual(response.status, .ok)
                let state = try response.content.decode(CardRoomState.self)
                XCTAssertEqual(state.hand, game.hands[0])
                for card in game.hands[1] + game.hands[2] + game.hands[3] + game.deck {
                    XCTAssertFalse(response.body.string.contains(card.id.uuidString))
                }
            }
            let outsider = User(subject: "outsider")
            try await outsider.create(on: app.db)
            let outsideToken = String(repeating: "b", count: 64)
            try await UserSession(userID: outsider.requireID(), hash: tokenHash(outsideToken), expiresAt: Date().addingTimeInterval(3600)).create(on: app.db)
            try await app.test(.GET, "v1/rooms/ABCDEF1234", headers: HTTPHeaders([("Authorization", "Bearer \(outsideToken)")])) { response async throws in
                XCTAssertEqual(response.status, .forbidden)
            }
            room.expiresAt = .distantPast; try await room.update(on: app.db)
            try await app.test(.GET, "v1/rooms/ABCDEF1234", headers: header) { response async throws in
                XCTAssertEqual(response.status, .notFound)
            }
            try await app.asyncShutdown()
        } catch { try await app.asyncShutdown(); throw error }
    }
}
