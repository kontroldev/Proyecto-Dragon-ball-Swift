//
//  SinglePlanetService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener los datos de un solo planeta de una API específica.
class SinglePlanetService: SinglePlanetProtocol {
    /// Obtiene los datos de un solo planeta de manera asíncrona.
    /// - Parameters:
    ///   - id: El identificador único del planeta.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los datos del planeta.
    /// - Returns: Los datos del planeta obtenidos.
    func getSinglePlanet(id: Int) async throws -> SinglePlanet {
        do{
            // Construye la URL para obtener los datos del planeta específico.
            let singlePlanetURL = "https://dragonball-api.com/api/planets/\(id)"
            
            // Verifica si la URL es válida.
            guard let url = URL(string: singlePlanetURL) else {
                throw ApiError.invalidURL
            }
            
            // Realiza la solicitud de datos de manera asíncrona.
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica si la respuesta de la solicitud es válida (código de estado HTTP 200).
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ApiError.invalidURL
            }
            
            // Decodifica los datos de respuesta en la estructura SinglePlanet.
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(SinglePlanet.self, from: data)
            
        }catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
