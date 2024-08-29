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
    var favoriteCharactersIDs: [FavoriteCharacter] = []
    var favoriteCharacters: [CharactersModel] = [] //Modelo con todos los datos de los personajes favoritos
    var isLoading: Bool = false
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
            favoriteCharactersIDs.append(character)
            try await favoriteCharactersDataBaseService.addToFavorites(character: character)
            await getFavoriteCharactersIDs()
        } catch {
            showError = true
            errorMessage = "Error al agregar a favoritos"
        }
    }
    
    
    /// Obtiene la lista de personajes favoritos desde la base de datos de Firestore.
    ///
    /// Esta función actualiza la lista local `favoriteCharacters` con los datos obtenidos desde el servicio de Firestore `favoriteCharactersDataBaseService`.
    func getFavoriteCharactersIDs() async {
        do {
            favoriteCharactersIDs = try await favoriteCharactersDataBaseService.getFavorites()
        } catch {
            showError = true
            errorMessage = "Error al obtener personajes favoritos"
        }
    }
    
    
    /// Obtiene los modelos de personajes favoritos a partir de datos provenientes de la base de datos y la API.
    ///
    /// Esta función realiza las siguientes acciones:
    ///
    /// 1. **Crea un conjunto de IDs de personajes favoritos:** Convierte la lista `favoriteCharactersIDs` (que se asume contiene objetos con una propiedad `characterID`) en un conjunto (`Set`) para facilitar búsquedas eficientes.
    /// 2. **Combina los personajes de ambas fuentes:** Concatena las listas `favoriteCharactersFromDB` y `favoriteCharactersFromDBZ` en una sola lista `allCharacters`, que contiene todos los personajes de ambos endpoints de la API.
    /// 3. **Filtra los personajes favoritos:** Itera sobre `allCharacters` y mantiene solo aquellos personajes cuyo ID esté presente en el conjunto `favoriteCharacterIDsSet`. Los personajes resultantes se almacenan en la propiedad `favoriteCharacters`.
    ///
    /// - Parameters:
    ///     - favoriteCharactersFromDB: Lista de modelos de personajes de Dragon Ball provenientes de la API.
    ///     - favoriteCharactersFromDBZ: Lista de modelos de personajes de Dragon Ball Z provenientes de la API.
    @MainActor
    func getFavoriteCharactersModels(favoriteCharactersFromDB: [CharactersModel], favoriteCharactersFromDBZ: [CharactersModel]) {
        //Creación de un Set (Recordar que los Set no permiten duplicidad de elementos y son más rápidos a la hora de iterar elementos)
        let favoriteCharacterIDsSet = Set(favoriteCharactersIDs.map { $0.characterID })
            
        let allCharacters = favoriteCharactersFromDB + favoriteCharactersFromDBZ
            
        favoriteCharacters = allCharacters.filter { favoriteCharacterIDsSet.contains(String( $0.id)) }
    }
    
    
    /// Verifica si un personaje está en la lista de favoritos.
    ///
    /// - Parameter characterID: El ID del personaje a buscar.
    /// - Returns: `true` si el personaje está en favoritos, `false` en caso contrario.
    func checkIsFavorite(characterID: String) async -> Bool {
        return favoriteCharactersIDs.contains(where: { $0.characterID == characterID })
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
            favoriteCharactersIDs.removeAll(where: { $0.characterID == characterID })
            try await favoriteCharactersDataBaseService.deleteFavoriteCharacter(characterID: characterID)
            await getFavoriteCharactersIDs()
            return true
        } catch {
            showError = true
            errorMessage = "No se pudo eliminar el personaje desde favoritos"
            return false
        }
    }
}
