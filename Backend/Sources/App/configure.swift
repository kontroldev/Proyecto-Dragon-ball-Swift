import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    guard let databaseURL = Environment.get("DATABASE_URL"),
        let clientID = Environment.get("GOOGLE_CLIENT_ID"), !clientID.isEmpty
    else {
        throw Abort(
            .internalServerError, reason: "Configura DATABASE_URL y GOOGLE_CLIENT_ID antes de arrancar.")
    }
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = Int(Environment.get("PORT") ?? "8080") ?? 8080
    app.routes.defaultMaxBodySize = "16kb"
    app.databases.use(try .postgres(url: databaseURL, maxConnectionsPerEventLoop: 1), as: .psql)
    app.migrations.add(CreateSchema())
    app.migrations.add(CreateCardRooms())
    // En Vercel las migraciones se ejecutan una vez desde el equipo de desarrollo.
    // Evitamos carreras entre instancias durante un arranque en frío.
    if Environment.get("AUTO_MIGRATE") == "true" { try await app.autoMigrate() }
    try routes(app, googleClientID: clientID)
    cardRoomRoutes(app)
}
