//
//  NetworkClient.swift
//  DragonBallSwift
//
//  Created by Josep Cerdá Penadés on 16/7/24.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {

    let urlSession: URLSessionProtocol
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func call<T>(urlString: String,
                 method: NetworkMethod,
                 queryParams: [String: Any]? = nil,
                 of type: T.Type) async throws -> T where T: Decodable {

        var urlComponents = URLComponents(string: urlString)
        // Query params
        if let queryParams {
            urlComponents?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        guard let url = urlComponents?.url else {
            throw ApiError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        do {
            let (data, response) = try await urlSession.getDataFrom(request, type: T.self)
            guard let response = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse
            }
            Log.thisRequest(response, data: data, request: request)
            if (200..<300).contains(response.statusCode) {
                return try JSONDecoder().decode(T.self, from: data)
            } else if (400..<499).contains(response.statusCode) {
                throw ApiError.notFound
            } else if response.statusCode == 500 {
                throw ApiError.clientError
            } else {
                throw ApiError.badResponse
            }
        } catch {
            throw ApiError.badRequest
        }
    }
}
