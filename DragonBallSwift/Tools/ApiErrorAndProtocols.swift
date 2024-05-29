//
//  ProtocolsAndError.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

// MARK: - Enumeras los caso de error de la Api
enum ApiError: Error {
    case invalidURL
    case invalidResponse
}

// MARK: - Establece Protocolos para llamada api, para todos los personajes
protocol AllCheractersProtocols{
    func getAllCheracters() async throws -> Characters
}

// MARK: - Establece Protocolos para llamada api, para todos los planetas
protocol AllPlanetsProtocols {
    func getAllPlanets() async throws -> Planets
}

// MARK: - Establece Protocolos para llamada api, un personage
protocol SingleCharacterProtocol {
    func getSingleCherater(id: Int) async throws -> SingleCharacter
}

// MARK: - Establece Protocolos para llamada api, un planeta
protocol SinglePlanetProtocol {
    func getSinglePlanetProtocol(di: Int) async throws -> SinglePlanet
}
