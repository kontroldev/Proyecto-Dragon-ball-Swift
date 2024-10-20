//
//  FavoritesViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 30-07-24.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel: CheractersProtocols {
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
    
    @MainActor
    func addToFavorites(characterID: Int) async {
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
    /// Esta función actualiza la lista local `favoriteCharacters` con los datos obtenidos
    /// desde el servicio de Firestore `favoriteCharactersDataBaseService`.
    
    @MainActor
    func getFavoriteCharactersIDs() async {
        do {
            favoriteCharactersIDs = try await favoriteCharactersDataBaseService.getFavorites()
        } catch {
            showError = true
            errorMessage = "Error al obtener personajes favoritos"
        }
    }

    /// - Descripción:
    ///   ---------
    /// Esta función asíncrona recupera y filtra los personajes favoritos de varias series del universo
    /// Dragon Ball (`Dragon Ball`, `Dragon Ball Z`, `Dragon Ball GT`, `Dragon Ball Super` y
    /// `Dragons`). Utiliza servicios externos para obtener los personajes de cada serie y luego filtra
    ///  aquellos cuyos identificadores coinciden con los IDs almacenados en una lista de personajes favoritos.
    ///
    /// - Detalles:
    ///   ------
    ///  *1.-  Anotación  `@MainActor` :  Asegura que la función se ejecuta en el hilo principal,
    ///  lo cual es importante para actualizar la UI de forma segura.
    ///  *2.-  Asincronía: Usa `async` y `await` para realizar solicitudes asíncronas al servicio
    ///  `charactersService`, evitando bloquear el hilo principal.
    ///  *3.- Agrupación y filtrado: Combina los personajes obtenidos de las distintas series y los filtra,
    ///  seleccionando solo aquellos que coinciden con los IDs favoritos.
    ///  *4.- Manejo de errores: Usa `do-catch` para capturar cualquier posible error durante la obtención de personajes.
    ///
    /// - Ejecución:
    ///   --------
    ///  1.- Solicita los personajes de varias series.
    ///  2.- Crea un conjunto `(Set)` de los IDs de personajes favoritos.
    ///  3.- Combina todos los personajes y filtra solo aquellos que estén en el conjunto de favoritos.
    ///  -------------------------------------------------------------------
    ///  Es una función diseñada para manejar personajes favoritos de manera eficiente y segura desde múltiples fuentes.
    
    @MainActor
    func getFavoriteCharactersModels() async {
        do{
            let favoriteCharacterFromDB = try await getCharacters("dragonball")
            let favoriteCharacterFromDZ = try await getCharacters("dragonballz")
            let favoriteCharacterFromDGT = try await getCharacters("dragonballgt")
            let favoriteCharacterFromDS = try await getCharacters("dragonballsuper")
            let favoriteCharacterFromDBD = try await getCharacters("dragons")
            let favoriteCharacterIDsSet = Set(favoriteCharactersIDs.map { $0.characterID })
            let allCharacters = favoriteCharacterFromDB + favoriteCharacterFromDZ + favoriteCharacterFromDGT + favoriteCharacterFromDS + favoriteCharacterFromDBD
            favoriteCharacters = allCharacters.filter{ favoriteCharacterIDsSet.contains(Int($0.id))}
        }catch{
            
        }
    }
    
    /// Verifica si un personaje está en la lista de favoritos.
    ///
    /// - Parameter characterID: El ID del personaje a buscar.
    /// - Returns: `true` si el personaje está en favoritos, `false` en caso contrario.
    
    @MainActor
    func checkIsFavorite(characterID: Int) async -> Bool {
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

    @MainActor
    func removeFromFavorites(characterID: Int) async -> Bool {
        do {
            favoriteCharacters.removeAll(where: { $0.id == characterID })
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
