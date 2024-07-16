//
//  AllPlanetsService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener todos los planetas de una API específica.
class AllPlanetsService: AllPlanetsProtocols {

    /// NetworkClientProtocol se encarga de extraer las llamadas de `URLSession.shared`
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    /// URL de la API que proporciona todos los planetas.
    let allPlanetsURL = "https://dragonball-api.com/api/planets?page=1&limit=58"
    
    /// Obtiene todos los planetas de la API de manera asíncrona.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los planetas.
    /// - Returns: La lista de planetas obtenidos.
    func getAllPlanets() async throws -> Planets {
        do {
            return try await networkClient.call(urlString: allPlanetsURL,
                                                method: .get,
                                                queryParams: nil,
                                                of: Planets.self)
            
        }catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
