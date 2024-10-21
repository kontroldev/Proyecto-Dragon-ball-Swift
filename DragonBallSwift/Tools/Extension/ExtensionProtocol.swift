//
//  ExtensionProtocol.swift
//  DragonBallSwift
//
//  Created by Esteban Pérez Castillejo on 7/10/24.
//

import Foundation

extension CheractersProtocols {
    func getCharacters(_ referent: String) async throws -> [CharactersModel] {
        do{
            let characterURL = "https://www.dragonballapi.com/" + referent
            guard let url = URL(string: characterURL) else {
                throw ApiError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([CharactersModel].self, from: data)
        }catch {
            throw error
        }
    }
}
