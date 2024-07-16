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
    case clientError
    case notFound
    case badResponse
    case decodeError
    case badRequest
}

// MARK: - Protocolo que define la interfaz para obtener todos los personajes.
protocol AllCheractersProtocols{
    func getAllCheracters() async throws -> Characters
}

// MARK: - Protocolo que define la interfaz para obtener todos los planetas.
protocol AllPlanetsProtocols {
    func getAllPlanets() async throws -> Planets
}

// MARK: - Protocolo que define la interfaz para obtener los datos de un solo personaje.
protocol SingleCharacterProtocol {
    func getSingleCherater(id: Int) async throws -> SingleCharacter
}

// MARK: - Protocolo que define la interfaz para obtener los datos de un solo planeta.
protocol SinglePlanetProtocol {
    func getSinglePlanet(id: Int) async throws -> SinglePlanet
}
