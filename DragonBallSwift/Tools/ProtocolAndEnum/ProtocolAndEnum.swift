//
//  ProtocolAndEnum.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//
//  ⚠️ ARREGLADO (ver comentarios "FIX"):
//  El enum ApiError solo tenía `invalidURL` e `invalidResponse`, pero
//  NetworkClient.swift ya usaba `.notFound`, `.clientError`, `.badResponse`
//  y `.badRequest`, que no existían. Esto no daba error porque
//  NetworkClient.swift no estaba añadido al target de Xcode todavía.
//  En cuanto lo añadas, esto es lo que necesita para compilar.

import Foundation

// MARK: - Enumera los casos de Login para Firebase
enum UserLoginState: Int {
    case loggedOut, loggedIn
}

// MARK: - Enumera los casos de error de la API
// FIX: se añaden los casos que faltaban y se implementa LocalizedError
// para poder mostrar un mensaje real al usuario (antes se guardaba "").
enum ApiError: Error {
    case invalidURL
    case invalidResponse
    case notFound                 // 400...499
    case serverError              // 500...599 (antes se llamaba, por error, "clientError")
    case badResponse              // cualquier otro código fuera de rango
    case decodingFailed(Error)    // FIX: antes se perdía el error real de decodificación
    case requestFailed(Error)     // FIX: antes se perdía el error real de red
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL de la petición no es válida."
        case .invalidResponse:
            return "El servidor no ha devuelto una respuesta válida."
        case .notFound:
            return "No se ha encontrado la información solicitada."
        case .serverError:
            return "El servidor de la API está teniendo problemas. Inténtalo más tarde."
        case .badResponse:
            return "Ha ocurrido un error inesperado al conectar con el servidor."
        case .decodingFailed:
            return "Los datos recibidos no tienen el formato esperado."
        case .requestFailed:
            return "No se ha podido completar la conexión. Comprueba tu conexión a internet."
        }
    }
}

// MARK: - Protocolo que define la interfaz para obtener todos los personajes.
protocol CheractersProtocols {
    func getCharacters(_ referent: String) async throws -> [CharactersModel]
}

