//
//  DragonBallModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation
import SwiftUI

struct CharactersModel: Codable  {
    let id: Int
    let name: String
    let genre: String
    let race: String
    let image: String
    let planet: String
    let description, biography: String
}


// MARK: - Single Characters Dragon Ball
struct SingleCharacterModel: Codable {
    let id: Int
    let name, genre, race: String
    let image: String
    let planet, description, biography: String
    let transformations: [Transformation]
}

struct Transformation: Codable {
    let id, title: String
    let image: String
    let description: String
}

// MARK: -DragonsModel
struct DragonsModel: Codable {
    let id: Int
    let name: String
    let image: String
    let description: String
    let biography: String
}

struct ItemMenu: Identifiable {
    var id = UUID()
    var name: String
    var imegenName: String
    var destination: AnyView
}

enum GameNames: String {
//    case none = ""
    case memoryGame = "Memory game"
    case tetrix = "Tetrix"
}

struct GameItemMenu: Identifiable {
    var id = UUID()
    var name: GameNames
    var imegenName: String
    var destination: AnyView
}
