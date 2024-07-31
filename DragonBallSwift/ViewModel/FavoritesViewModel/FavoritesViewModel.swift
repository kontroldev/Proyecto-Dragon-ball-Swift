//
//  FavoritesViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 30-07-24.
//

import Foundation

@Observable
class FavoritesViewModel {
    private let favoriteCharactersDataBaseService = FavoriteCharacterDataBaseService()
    var favoriteCharacters: [FavoriteCharacter] = []
    var showError: Bool = false
    var errorMessage: String = ""
    
    func addToFavorites(characterID: String) async {
        do {
            let character = FavoriteCharacter(characterID: characterID)
            try await favoriteCharactersDataBaseService.addToFavorites(character: character)
        } catch {
            showError = true
            errorMessage = "Error al agregar a favoritos"
        }
    }
    
    func getFavoriteCharacters() async {
        do {
            favoriteCharacters = try await favoriteCharactersDataBaseService.getFavorites()
        } catch {
            showError = true
            errorMessage = "Error al obtener personajes favoritos"
        }
    }
    
    func checkIsFavorite(characterID: String) async -> Bool {
        return favoriteCharacters.contains(where: { $0.characterID == characterID })
    }
    
    func removeFromFavorites(characterID: String) {
//        favoriteCharacters.removeAll(where: { $0 == characterID })
    }
}
