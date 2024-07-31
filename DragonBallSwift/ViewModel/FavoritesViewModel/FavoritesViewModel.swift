//
//  FavoritesViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 30-07-24.
//

import Foundation

@Observable
class FavoritesViewModel {
    var favoriteCharacters: [String] = []
    
    func addToFavorites(characterID: String) {
        favoriteCharacters.append(characterID)
    }
    
    func checkIsFavorite(characterID: String) -> Bool {
        return favoriteCharacters.contains(where: { $0 == characterID })
    }
    
    func removeFromFavorites(characterID: String) {
        favoriteCharacters.removeAll(where: { $0 == characterID })
    }
}
