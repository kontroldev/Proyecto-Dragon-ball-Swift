//
//  SingleCheracterService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener los datos de un solo personaje de una API específica.
class SingleCheracterService: SingleCharacterProtocol{
    
    /// Obtiene los datos de un solo personaje de manera asíncrona.
    /// - Parameters:
    ///   - id: El identificador único del personaje.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los datos del personaje.
    /// - Returns: Los datos del personaje obtenidos.
    func getSingleCherater(id: Int) async throws -> SingleCharacter {
        do {
            // Construye la URL para obtener los datos del personaje específico.
            let singleCheraterURL = "https://dragonball-api.com/api/characters/\(id)"
            
            // Verifica si la URL es válida.
            guard let url = URL(string: singleCheraterURL) else {
                throw ApiError.invalidURL
            }
            
            // Realiza la solicitud de datos de manera asíncrona.
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica si la respuesta de la solicitud es válida (código de estado HTTP 200).
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            // Decodifica los datos de respuesta en la estructura SingleCharacter.
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(SingleCharacter.self, from: data)
            
        } catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
