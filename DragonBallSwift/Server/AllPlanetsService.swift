//
//  AllPlanetsService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener todos los planetas de una API específica.
class AllPlanetsService: AllPlanetsProtocols {
    /// URL de la API que proporciona todos los planetas.
    let allPlanetsURL = "https://dragonball-api.com/api/planets?page=1&limit=58"
    
    /// Obtiene todos los planetas de la API de manera asíncrona.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los planetas.
    /// - Returns: La lista de planetas obtenidos.
    func getAllPlanets() async throws -> Planets {
        do {
            // Verifica si la URL es válida.
            guard let url = URL(string: allPlanetsURL) else {
                throw ApiError.invalidURL
            }
            
            // Realiza la solicitud de datos de manera asíncrona.
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica si la respuesta de la solicitud es válida (código de estado HTTP 200).
            guard let reponse = response as? HTTPURLResponse, reponse.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            // Decodifica los datos de respuesta en la estructura Planets.
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Planets.self, from: data)
            
        }catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
