//
//  SinglePlanetModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

struct SinglePlanet: Codable {
    let id: Int
    let name: String
    let isDestroyed: Bool
    let description: String
    let image: String
    let deletedAt: Date?
    let characters: [Character]
}


