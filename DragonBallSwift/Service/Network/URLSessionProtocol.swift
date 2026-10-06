import Foundation

protocol URLSessionProtocol: Sendable {
    func getDataFrom(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func getDataFrom(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
