//
//  AllDragonsDataService.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation

class AllDragonsDataService: AllDragonsProtocols {
    
    ///Obtiene todos los personajes de Dragonball API
    /// - Returns: Una instancia de `Dragons` la cual contiene toda la información básica de cada personaje
    func getDragons() async throws -> [DragonsModel] {
        do {
            let allDragonsURL = "https://apidragonball.vercel.app/dragons/"
            guard let url = URL(string: allDragonsURL) else {
                throw ApiError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([DragonsModel].self, from: data)
            
        }catch{
            throw error
        }
    }
    
}
