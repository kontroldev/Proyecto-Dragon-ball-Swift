//
//  URLSessionProtocol.swift
//  DragonBallSwift
//
//  Created by Josep Cerdá Penadés on 16/7/24.
//

import Foundation

protocol URLSessionProtocol {
    func getDataFrom<T: Decodable>(_ request: URLRequest,
                                   type: T.Type) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {
    func getDataFrom<T: Decodable>(_ request: URLRequest,
                                   type: T.Type) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
