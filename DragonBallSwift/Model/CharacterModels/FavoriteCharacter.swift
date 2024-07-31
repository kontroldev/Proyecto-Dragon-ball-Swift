//
//  FavoriteCharacter.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 31-07-24.
//

import Foundation

struct FavoriteCharacter: Decodable {
    let characterID: String
    
    var dictionary: [String: Any] {
        return ["characterID": characterID]
    }
}
