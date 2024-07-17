//
//  ApiProtocol.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation

// MARK: - Protocolo que define la interfaz para obtener todos los personajes.
protocol AllCheractersProtocols{
    func getCharacters(_ referent: String) async throws -> [CharactersModel]
}

// MARK: - Protocolo que define la interfaz para obtener todos los planetas.
protocol AllDragosProtocols {
    func getDragons() async throws -> [DragonsModel]
}

// MARK: - Protocolo que define la interfaz para obtener los datos de un solo personaje.
protocol SingleCharacterProtocol {
    func getSingleCharacter(id: String) async throws -> SingleCharacters
}

// MARK: - Protocolo que define la interfaz para obtener los datos de un solo planeta.
protocol SingleDragonsProtocol {
    func getSingleDragos(id: String) async throws -> SingleCharacters
}
