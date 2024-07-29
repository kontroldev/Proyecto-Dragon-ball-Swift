//
//  SinglePlanetService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener los datos de un solo planeta de una API específica.
class SinglePlanetService: SinglePlanetProtocol {

    /// NetworkClientProtocol se encarga de extraer las llamadas de `URLSession.shared`
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    /// Obtiene los datos de un solo planeta de manera asíncrona.
    /// - Parameters:
    ///   - id: El identificador único del planeta.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los datos del planeta.
    /// - Returns: Los datos del planeta obtenidos.
    func getSinglePlanet(id: Int) async throws -> SinglePlanet {
        do{
            // Construye la URL para obtener los datos del planeta específico.
            let singlePlanetURL = "https://dragonball-api.com/api/planets/\(id)"
            return try await networkClient.call(urlString: singlePlanetURL,
                                                method: .get,
                                                queryParams: nil,
                                                of: SinglePlanet.self)
        }catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
