//
//  AllCheracteersService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation


/// Servicio para obtener todos los personajes de una API específica.
class AllCheracteersService: AllCheractersProtocols {
    
    /// URL de la API que proporciona todos los personajes.
    let allCheractersURL = "https://dragonball-api.com/api/characters?page=1&limit=58"
    
    /// Obtiene todos los personajes de la API de manera asíncrona.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los personajes.
    /// - Returns: La lista de personajes obtenidos.
    func getAllCheracters() async throws -> Characters {
        do{
            // Verifica si la URL es válida.
            guard let url = URL(string: allCheractersURL) else {
                throw ApiError.invalidURL
            }
            
            // Realiza la solicitud de datos de manera asíncrona.
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica si la respuesta de la solicitud es válida (código de estado HTTP 200).
            guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            // Decodifica los datos de respuesta en la estructura Characters.
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Characters.self, from: data)
            
        }catch{
            // Propaga cualquier error que ocurra durante el proceso.
           throw error
        }
    }
}
