//
//  SingleCheranter.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

// MARK: - SingleCharacter
struct SingleCharacter: Codable {
    let id: Int
    let name, ki, maxKi, race: String
    let gender, description: String
    let image: String
    let affiliation: String
    let deletedAt: Date?
    let originPlanet: OriginPlanet
    let transformations: [Transformation]
}

// MARK: - OriginPlanet
struct OriginPlanet: Codable {
    let id: Int
    let name: String
    let isDestroyed: Bool
    let description: String
    let image: String
    let deletedAt: Date?
}

// MARK: - Transformation
struct Transformation: Codable {
    let id: Int
    let name: String
    let image: String
    let ki: String
    let deletedAt: Date?
}
