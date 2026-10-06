import Foundation
import Observation

@Observable
@MainActor
final class SessionStore {
    static let shared = SessionStore()
    private(set) var credential: BackendSession?
    var userID: String? { credential?.userID }
    private var started = false
    private let keychain = SessionKeychain()

    func startListening() async {
        guard !started else { return }
        started = true
        do {
            guard let stored = try keychain.load() else { return }
            guard stored.expiresAt > Date().timeIntervalSince1970 else {
                try keychain.clear()
                return
            }
            credential = stored
            _ = try await BackendClient().send("GET", path: "v1/me", token: stored.token)
        } catch {
            // Un fallo de red no elimina la sesión; un 401 sí la invalida en BackendClient.
        }
    }

    func signIn(idToken: String) async throws {
        let body = try JSONEncoder().encode(["idToken": idToken])
        let data = try await BackendClient().send("POST", path: "v1/auth/google", body: body)
        let session = try JSONDecoder().decode(BackendSession.self, from: data)
        try keychain.save(session)
        credential = session
    }

    func invalidate(token: String) {
        guard credential?.token == token else { return }
        credential = nil
        try? keychain.clear()
    }

    func signOut() async throws {
        let closingToken = credential?.token
        if let closingToken {
            do {
                _ = try await BackendClient().send("DELETE", path: "v1/auth/session", token: closingToken)
            } catch BackendError.http(401) {
                // La sesión ya estaba revocada; todavía hay que limpiar Google y Keychain.
            }
        }
        guard credential == nil || credential?.token == closingToken else { return }
        try keychain.clear()
        credential = nil
        GoogleService().logout()
    }
}

@Observable
@MainActor
final class LoginViewModel {
    private let googleService = GoogleService()
    var isLoading = false
    var showError = false
    var errorMessage = ""

    func signInWithGoogle() async -> Bool {
        guard !isLoading else { return false }
        isLoading = true
        defer { isLoading = false }
        do { return try await googleService.authenticate() } catch {
            errorMessage = error.localizedDescription
            showError = true
            return false
        }
    }
}
