//
//  DragonBallModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation
import SwiftUI

// MARK: - Modelo de todo los personajes
struct CharactersModel: Codable  {
    let id: Int
    let name: String
    let genre: String
    let race: String
    let image: String
    let planet: String
    let description, biography: String
    let transformations: [Transformation]
}

// MARK: - Transformation
struct Transformation: Codable {
    let id: Int?
    let title: String?
    let image: String
    let description: String
//    let trans: Int?
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
