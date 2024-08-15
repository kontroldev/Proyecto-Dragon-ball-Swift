//
//  AllCharactersDBDataService.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation

class AllCharactersDBDataService: AllCheractersProtocols {
    
    ///Obtiene todos los personajes de Dragonball API
    /// - Returns: Una instancia de `CharactersModel` la cual contiene toda la información básica de cada personaje
    func getCharacters(_ referent: String) async throws -> [CharactersModel] {
        do {
            let allCharactersURL = "https://www.dragonballapi.com/\(referent)/"
            guard let url = URL(string: allCharactersURL) else {
                throw ApiError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([CharactersModel].self, from: data)
            
        }catch{
            throw error
        }
    }
}
