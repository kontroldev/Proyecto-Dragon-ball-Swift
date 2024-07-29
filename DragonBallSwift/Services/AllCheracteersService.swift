//
//  AllCheracteersService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation


/// Servicio para obtener todos los personajes de una API específica.
class AllCheracteersService: AllCheractersProtocols {

    /// NetworkClientProtocol se encarga de extraer las llamadas de `URLSession.shared`
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    /// URL de la API que proporciona todos los personajes.
    let allCheractersURL = "https://dragonball-api.com/api/characters?page=1&limit=58"
    
    /// Obtiene todos los personajes de la API de manera asíncrona.
    /// - Throws: Se lanza un error si ocurre algún problema durante la obtención de los personajes.
    /// - Returns: La lista de personajes obtenidos.
    func getAllCheracters() async throws -> Characters {
        do{
            return try await networkClient.call(urlString: allCheractersURL,
                                                method: .get,
                                                queryParams: nil,
                                                of: Characters.self)
            
        }catch{
            // Propaga cualquier error que ocurra durante el proceso.
           throw error
        }
    }
}
