import Fluent
import Vapor

final class User: Model, Authenticatable, @unchecked Sendable {
    static let schema = "users"
    @ID(key: .id) var id: UUID?
    @Field(key: "google_subject") var googleSubject: String
    init() {}
    init(subject: String) { googleSubject = subject }
}

final class UserSession: Model, @unchecked Sendable {
    static let schema = "sessions"
    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Field(key: "token_hash") var tokenHash: String
    @Field(key: "expires_at") var expiresAt: Date
    init() {}
    init(userID: UUID, hash: String, expiresAt: Date) {
        $user.id = userID
        tokenHash = hash
        self.expiresAt = expiresAt
    }
}

final class Favorite: Model, @unchecked Sendable {
    static let schema = "favorites"
    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Field(key: "character_id") var characterID: Int
    init() {}
    init(userID: UUID, characterID: Int) {
        $user.id = userID
        self.characterID = characterID
    }
}

struct CreateSchema: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(User.schema).id()
            .field("google_subject", .string, .required).unique(on: "google_subject").create()
        try await db.schema(UserSession.schema).id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("token_hash", .string, .required).unique(on: "token_hash")
            .field("expires_at", .datetime, .required).create()
        try await db.schema(Favorite.schema).id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("character_id", .int, .required).unique(on: "user_id", "character_id").create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema(Favorite.schema).delete()
        try await db.schema(UserSession.schema).delete()
        try await db.schema(User.schema).delete()
    }
}
