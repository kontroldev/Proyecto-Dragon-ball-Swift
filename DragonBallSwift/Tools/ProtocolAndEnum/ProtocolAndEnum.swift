//
//  ProtocolAndEnum.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//
import Foundation

// MARK: - Opciones de inicio de sesión
enum UserLoginState: Int {
    case loggedOut, loggedIn
}

// MARK: - Enumera los casos de error de la API
enum ApiError: Error {
    case invalidURL
    case httpError(Int)
    case invalidResponse
    case notFound
    case serverError
    case badResponse
    case decodingFailed(Error)
    case requestFailed(Error)
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .httpError(let status):
            return "No se pudo completar la petición (HTTP \(status))."
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
