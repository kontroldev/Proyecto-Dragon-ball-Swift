//
//  SingleCheracterService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Servicio para obtener los datos de un solo personaje de una API específica.
class SingleCheracterService: SingleCharacterProtocol{
    
    /// NetworkClientProtocol se encarga de extraer las llamadas de `URLSession.shared`
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    /// Obtiene los datos de un solo personaje de manera asíncrona.
    /// - Parameters:
    ///   - id: El identificador único del personaje.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los datos del personaje.
    /// - Returns: Los datos del personaje obtenidos.
    func getSingleCherater(id: Int) async throws -> SingleCharacter {
        do {
            // Construye la URL para obtener los datos del personaje específico.
            let singleCheraterURL = "https://dragonball-api.com/api/characters/\(id)"
            return try await networkClient.call(urlString: singleCheraterURL,
                                                method: .get,
                                                queryParams: nil,
                                                of: SingleCharacter.self)
            
        } catch {
            // Propaga cualquier error que ocurra durante el proceso.
            throw error
        }
    }
}
