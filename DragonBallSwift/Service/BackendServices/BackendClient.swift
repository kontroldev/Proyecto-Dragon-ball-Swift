import Foundation
import Security

struct BackendSession: Codable, Sendable {
    let userID: String
    let token: String
    let expiresAt: Double
}

enum BackendError: LocalizedError {
    case configuration, invalidResponse
    case http(Int)
    case keychain(OSStatus)
    var errorDescription: String? {
        switch self {
        case .configuration: "Configura BackendBaseURL con la dirección HTTPS del servidor en Vercel."
        case .invalidResponse: "El servidor ha devuelto una respuesta no válida."
        case .http(401): "Tu sesión ha caducado. Vuelve a iniciar sesión."
        case .http: "No se pudo completar la operación. Inténtalo de nuevo."
        case .keychain: "No se ha podido guardar la sesión de forma segura."
        }
    }
}

/// Solo las credenciales de sesión se guardan en el llavero del dispositivo.
struct SessionKeychain {
    private let service = "DragonBallSwift.VaporSession"
    private var query: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: "current",
        ]
    }
    func load() throws -> BackendSession? {
        var search = query
        search[kSecReturnData as String] = true
        search[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        let status = SecItemCopyMatching(search as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = item as? Data else { throw BackendError.keychain(status) }
        return try JSONDecoder().decode(BackendSession.self, from: data)
    }
    func save(_ session: BackendSession) throws {
        let data = try JSONEncoder().encode(session)
        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if status == errSecItemNotFound {
            var record = query
            record[kSecValueData as String] = data
            record[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            let added = SecItemAdd(record as CFDictionary, nil)
            guard added == errSecSuccess else { throw BackendError.keychain(added) }
        } else if status != errSecSuccess {
            throw BackendError.keychain(status)
        }
    }
    func clear() throws {
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw BackendError.keychain(status)
        }
    }
}

@MainActor
struct BackendClient {
    let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func send(_ method: String, path: String, token: String? = nil, body: Data? = nil) async throws -> Data {
        guard let configured = Bundle.main.object(forInfoDictionaryKey: "BackendBaseURL") as? String,
            let base = URL(string: configured), base.scheme == "https", base.host != nil,
            !configured.contains("YOUR_PROJECT")
        else { throw BackendError.configuration }
        var request = URLRequest(url: base.appendingPathComponent(path))
        request.httpMethod = method
        request.timeoutInterval = 90
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token { request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw BackendError.invalidResponse }
        guard (200...299).contains(response.statusCode) else {
            if response.statusCode == 401, let token { SessionStore.shared.invalidate(token: token) }
            throw BackendError.http(response.statusCode)
        }
        return data
    }
}

@MainActor
final class APIFavoriteStore: FavoriteCharacterStoring {
    private let client: BackendClient
    var userID: String? { SessionStore.shared.userID }
    init(client: BackendClient = BackendClient()) { self.client = client }
    private func token() throws -> String {
        guard let credential = SessionStore.shared.credential,
            credential.expiresAt > Date().timeIntervalSince1970
        else {
            if let token = SessionStore.shared.credential?.token {
                SessionStore.shared.invalidate(token: token)
            }
            throw FavoriteStoreError.signInRequired
        }
        return credential.token
    }
    func addToFavorites(character: FavoriteCharacter) async throws {
        _ = try await client.send("PUT", path: "v1/favorites/\(character.characterID)", token: token())
    }
    func getFavorites() async throws -> [FavoriteCharacter] {
        let data = try await client.send("GET", path: "v1/favorites", token: token())
        return try JSONDecoder().decode([FavoriteCharacter].self, from: data)
    }
    func deleteFavoriteCharacter(characterID: Int) async throws {
        _ = try await client.send("DELETE", path: "v1/favorites/\(characterID)", token: token())
    }
}
