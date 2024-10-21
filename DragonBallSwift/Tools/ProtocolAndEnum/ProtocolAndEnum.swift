//
//  ProtocolAndEnum.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//

import Foundation

// MARK: - Enumeras los caso Login para FireBase
enum UserLoginState: Int {
    case loggedOut, loggedIn
}


// MARK: - Enumeras los caso de error de la Api
enum ApiError: Error {
    case invalidURL
    case invalidResponse
}



// MARK: - Protocolo que define la interfaz para obtener todos los personajes.
protocol CheractersProtocols{
    func getCharacters(_ referent: String) async throws -> [CharactersModel]
}

