//
//  ApiProtocol.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation

// MARK: - Protocolo que define la interfaz para obtener todos los personajes de dragonball-api.com
protocol AllCheractersProtocols {
    func getAllCheracters() async throws -> Characters
}

//// MARK: - Protocolo que define la interfaz para obtener todos los planetas.
//protocol AllDragonsProtocols {
//    func getDragons() async throws -> [DragonsModel]
//}
//
//// MARK: - Protocolo que define la interfaz para obtener los datos de un solo personaje.
//protocol SingleCharacterProtocol {
//    func getSingleCharacter(_ referent: String, id: String) async throws -> SingleCharacterModel
//}
//
//// MARK: - Protocolo que define la interfaz para obtener los datos de un solo planeta.
//protocol SingleDragonProtocol {
//    func getSingleDragos(id: String) async throws -> SingleCharacterModel
//}
