import CardRules
import Fluent
import SQLKit
import Vapor

final class CardRoom: Model, @unchecked Sendable {
    static let schema = "card_rooms"
    @ID(key: .id) var id: UUID?
    @Field(key: "code") var code: String
    @Field(key: "owner_id") var ownerID: UUID
    @Field(key: "payload") var payload: Data
    @Field(key: "expires_at") var expiresAt: Date
    init() {}
    init(code: String, user: UUID) throws {
        self.code = code
        ownerID = user
        payload = try JSONEncoder().encode(RoomPayload(members: [user], game: nil, version: 0))
        expiresAt = Date().addingTimeInterval(24 * 3600)
    }
}

struct RoomPayload: Codable, Sendable {
    var members: [UUID]
    var game: BattleGame?
    var version: Int
    func state(code: String, user: UUID) throws -> CardRoomState {
        guard let seat = members.firstIndex(of: user) else { throw Abort(.forbidden) }
        return CardRoomState(code: code, players: members.count, seat: seat, version: version, game: game)
    }
}

struct CreateCardRooms: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(CardRoom.schema).id()
            .field("code", .string, .required).unique(on: "code")
            .field("owner_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("payload", .data, .required)
            .field("expires_at", .datetime, .required).create()
    }
    func revert(on db: any Database) async throws { try await db.schema(CardRoom.schema).delete() }
}

extension CardRoomState: Content {}
extension CardRoomAction: Content {}

func cardRoomRoutes(_ app: Application) {
    let rooms = app.grouped("v1", "rooms").grouped(SessionAuthenticator(), User.guardMiddleware())
    rooms.post { req async throws -> CardRoomState in
        let user = try req.auth.require(User.self).requireID()
        let count = try await CardRoom.query(on: req.db).filter(\.$ownerID == user)
            .filter(\.$expiresAt > Date()).count()
        guard count < 5 else { throw Abort(.tooManyRequests, reason: "Ya tienes cinco salas activas. Reutiliza una sala existente.") }
        try await CardRoom.query(on: req.db).filter(\.$expiresAt <= Date()).delete()
        // Códigos no secuenciales; la pertenencia siempre se comprueba además del código.
        let room = try CardRoom(code: UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(10).uppercased(), user: user)
        try await room.create(on: req.db)
        return try JSONDecoder().decode(RoomPayload.self, from: room.payload).state(code: room.code, user: user)
    }
    rooms.get(":code") { req async throws -> CardRoomState in
        let user = try req.auth.require(User.self).requireID()
        let room = try await findRoom(req, db: req.db)
        return try JSONDecoder().decode(RoomPayload.self, from: room.payload).state(code: room.code, user: user)
    }
    rooms.post(":code", "join") { req async throws -> CardRoomState in
        let user = try req.auth.require(User.self).requireID()
        return try await lockedRoom(req) { room, payload in
            if !payload.members.contains(user) {
                guard payload.game == nil, payload.members.count < 4 else {
                    throw Abort(.conflict, reason: "La sala ya está completa.")
                }
                payload.members.append(user); payload.version += 1
            }
            return try payload.state(code: room.code, user: user)
        }
    }
    rooms.post(":code", "start") { req async throws -> CardRoomState in
        let user = try req.auth.require(User.self).requireID()
        return try await lockedRoom(req) { room, payload in
            guard payload.members.first == user else { throw Abort(.forbidden) }
            guard payload.members.count == 4 else { throw Abort(.conflict, reason: "Faltan jugadores: se necesitan cuatro.") }
            if payload.game == nil { payload.game = BattleGame(); payload.version += 1 }
            return try payload.state(code: room.code, user: user)
        }
    }
    rooms.post(":code", "actions") { req async throws -> CardRoomState in
        let user = try req.auth.require(User.self).requireID()
        let action = try req.content.decode(CardRoomAction.self)
        return try await lockedRoom(req) { room, payload in
            guard let seat = payload.members.firstIndex(of: user) else { throw Abort(.forbidden) }
            guard payload.version == action.version else { throw Abort(.conflict, reason: "La partida cambió. Actualiza antes de jugar.") }
            guard var game = payload.game, game.winner == nil, game.current == seat else {
                throw Abort(.conflict, reason: "No es tu turno.")
            }
            if action.draw {
                guard action.cardID == nil else { throw Abort(.badRequest) }
                game.drawAndPass(player: seat)
            } else {
                guard let id = action.cardID, let card = game.hands[seat].first(where: { $0.id == id }),
                      game.play(card, player: seat, chosenColor: action.color) else {
                    throw Abort(.badRequest, reason: "Carta o color no válidos.")
                }
            }
            payload.game = game; payload.version += 1
            return try payload.state(code: room.code, user: user)
        }
    }
}

private func findRoom(_ req: Request, db: any Database) async throws -> CardRoom {
    guard let code = req.parameters.get("code"), code.count == 10,
          let room = try await CardRoom.query(on: db).filter(\.$code == code.uppercased())
            .filter(\.$expiresAt > Date()).first() else { throw Abort(.notFound) }
    return room
}

/// Bloqueo PostgreSQL dentro de una transacción: protege también frente a otras instancias.
private func lockedRoom(
    _ req: Request,
    update: @Sendable @escaping (CardRoom, inout RoomPayload) throws -> CardRoomState
) async throws -> CardRoomState {
    try await req.db.transaction { db in
        guard let sql = db as? any SQLDatabase else { throw Abort(.internalServerError) }
        let found = try await findRoom(req, db: db)
        let id = try found.requireID()
        _ = try await sql.raw("SELECT id FROM card_rooms WHERE id = \(bind: id) FOR UPDATE").all()
        guard let room = try await CardRoom.find(id, on: db), room.expiresAt > Date() else { throw Abort(.notFound) }
        var payload = try JSONDecoder().decode(RoomPayload.self, from: room.payload)
        let result = try update(room, &payload)
        room.payload = try JSONEncoder().encode(payload)
        try await room.update(on: db)
        return result
    }
}
