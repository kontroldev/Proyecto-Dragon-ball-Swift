import JWTKit
import Vapor

struct GoogleIdentity: JWTPayload {
    let sub: String
    let iss: String
    let aud: AudienceClaim
    let exp: ExpirationClaim

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
        guard ["https://accounts.google.com", "accounts.google.com"].contains(iss), !sub.isEmpty else {
            throw Abort(.unauthorized, reason: "Identidad de Google no válida.")
        }
    }
}

protocol GoogleIdentityVerifying: Sendable {
    func verify(_ token: String, clientID: String, client: any Client) async throws -> String
}

/// Las claves públicas se renuevan periódicamente y se mantienen separadas de las sesiones.
actor GoogleIdentityVerifier: GoogleIdentityVerifying {
    private var keys = JWTKeyCollection()
    private var loadedAt = Date.distantPast

    func verify(_ token: String, clientID: String, client: any Client) async throws -> String {
        if Date().timeIntervalSince(loadedAt) > 3600 {
            try await reload(client: client)
        }
        let identity: GoogleIdentity
        do {
            identity = try await keys.verify(token, as: GoogleIdentity.self)
        } catch {
            // Una rotación de claves puede ocurrir antes de que caduque la caché.
            // Evita que tokens inválidos provoquen una petición a Google en cada intento.
            if Date().timeIntervalSince(loadedAt) > 60 {
                try await reload(client: client)
                identity = try await keys.verify(token, as: GoogleIdentity.self)
            } else {
                throw Abort(.unauthorized, reason: "Credenciales de Google no válidas.")
            }
        }
        try identity.aud.verifyIntendedAudience(includes: clientID)
        return identity.sub
    }

    private func reload(client: any Client) async throws {
        let response = try await client.get("https://www.googleapis.com/oauth2/v3/certs")
        guard response.status == .ok else { throw Abort(.serviceUnavailable) }
        let jwks = try response.content.decode(JWKS.self)
        let updated = JWTKeyCollection()
        try await updated.add(jwks: jwks)
        keys = updated
        loadedAt = Date()
    }
}
