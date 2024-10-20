//
//  CharactersServer.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//

import Foundation

class CharactersService: CheractersProtocols {

    /// **Obtiene todos los personajes de Dragonball API
    /// - Returns: Una instancia de `CharactersModel` la cual contiene toda la información básica de cada personaje

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
