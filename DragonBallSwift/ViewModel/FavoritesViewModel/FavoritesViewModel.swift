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
    
    /// Agrega un personaje a la lista de favoritos (en la memoria y en Firestore).
    ///
    /// Esta función realiza las siguientes acciones:
    /// 1. Crea un objeto `FavoriteCharacter` con el ID del personaje proporcionado.
    /// 2. Agrega este objeto a la lista local `favoriteCharacters`.
    /// 3. Intenta guardar el personaje en la base de datos de Firestore a través del servicio `favoriteCharactersDataBaseService`.
    /// 4. Actualiza la lista de favoritos llamando a `getFavoriteCharacters()`.
    /// 5. En caso de error, establece las variables `showError` y `errorMessage` para mostrar un mensaje al usuario.
    ///
    /// - Parameter characterID: El ID del personaje que se agregará a favoritos.
    func addToFavorites(characterID: String) async {
        do {
            let character = FavoriteCharacter(characterID: characterID)
            favoriteCharacters.append(character)
            try await favoriteCharactersDataBaseService.addToFavorites(character: character)
            await getFavoriteCharacters()
        } catch {
            showError = true
            errorMessage = "Error al agregar a favoritos"
        }
    }
    
    
    /// Obtiene la lista de personajes favoritos desde la base de datos de Firestore.
    ///
    /// Esta función actualiza la lista local `favoriteCharacters` con los datos obtenidos desde el servicio de Firestore `favoriteCharactersDataBaseService`.
    func getFavoriteCharacters() async {
        do {
            favoriteCharacters = try await favoriteCharactersDataBaseService.getFavorites()
        } catch {
            showError = true
            errorMessage = "Error al obtener personajes favoritos"
        }
    }
    
    
    /// Verifica si un personaje está en la lista de favoritos.
    ///
    /// - Parameter characterID: El ID del personaje a buscar.
    /// - Returns: `true` si el personaje está en favoritos, `false` en caso contrario.
    func checkIsFavorite(characterID: String) async -> Bool {
        return favoriteCharacters.contains(where: { $0.characterID == characterID })
    }
    
    
    /// Elimina un personaje de la lista de favoritos (De la memoria y de Firestore).
    ///
    /// Esta función realiza las siguientes acciones:
    /// 1. Elimina el personaje de la lista local `favoriteCharacters`.
    /// 2. Intenta eliminar el personaje de la base de datos.
    /// 3. Actualiza la lista de favoritos.
    /// 4. Devuelve `true` si la eliminación fue exitosa, `false` en caso contrario.
    ///
    /// - Parameter characterID: El ID del personaje a eliminar.
    /// - Returns: `true` si la eliminación fue exitosa, `false` si hubo un error.
    func removeFromFavorites(characterID: String) async -> Bool {
        do {
            favoriteCharacters.removeAll(where: { $0.characterID == characterID })
            try await favoriteCharactersDataBaseService.deleteFavoriteCharacter(characterID: characterID)
            await getFavoriteCharacters()
            return true
        } catch {
            showError = true
            errorMessage = "No se pudo eliminar el personaje desde favoritos"
            return false
        }
    }
}
