import App
import Vapor

@main
struct Server {
    static func main() async throws {
        let app = try await Application.make(Environment.detect())
        do {
            try await configure(app)
            try await app.execute()
            try await app.asyncShutdown()
        } catch {
            try await app.asyncShutdown()
            throw error
        }
    }
}
