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

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await urlSession.getDataFrom(request, type: T.self)
        } catch {
            throw ApiError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        Log.thisRequest(httpResponse, data: data, request: request)

        switch httpResponse.statusCode {
        case 200..<300:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError.decodingFailed(error)
            }
        case 400..<500:
            throw ApiError.notFound
        case 500..<600:
            throw ApiError.serverError
        default:
            throw ApiError.badResponse
        }
    }
}
