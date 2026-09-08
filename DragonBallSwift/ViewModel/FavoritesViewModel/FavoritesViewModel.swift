//
//  FavoritesViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 30-07-24.
//
//  CAMBIO IMPORTANTE: antes, para montar la lista de personajes favoritos,
//  se hacían 5 peticiones (una por cada saga: dragonball, dragonballz,
//  dragonballgt, dragonballsuper, dragons) contra la API que montó Juan
//  Pablo en Vercel. Esa API ya no está disponible.
//
//  Ahora se usa `AllCheracteersService`, que habla con dragonball-api.com
//  (viva, mantenida y ya la usábamos para el listado general de personajes).
//  Esa API trae TODOS los personajes en un único sitio, así que ya no hace
//  falta hacer 5 llamadas: con una sola de sobra.
//
//  Como el modelo que devuelve esa API (`Character`) no es igual que el
//  que ya usan las vistas (`CharactersModel`), se convierte con
//  `toCharactersModel()` (ver CharacterMapping.swift).

import Foundation
import Observation

@Observable
class FavoritesViewModel: @unchecked Sendable {
    private let favoriteCharactersDataBaseService = FavoriteCharacterDataBaseService()
    private let charactersService: AllCheractersProtocols

    var favoriteCharactersIDs: [FavoriteCharacter] = []
    var favoriteCharacters: [CharactersModel] = [] // Datos completos de los personajes favoritos
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""

    /// Se puede pasar un servicio distinto en los tests; por defecto usa el real.
    init(charactersService: AllCheractersProtocols = AllCheracteersService(networkClient: NetworkClient(urlSession: URLSession.shared))) {
        self.charactersService = charactersService
    }

    /// Agrega un personaje a la lista de favoritos (en la memoria y en Firestore).
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

    /// Obtiene la lista de IDs de personajes favoritos desde Firestore.
    @MainActor
    func getFavoriteCharactersIDs() async {
        do {
            favoriteCharactersIDs = try await favoriteCharactersDataBaseService.getFavorites()
        } catch {
            showError = true
            errorMessage = "Error al obtener personajes favoritos"
        }
    }

    /// Recupera los datos completos de los personajes marcados como favoritos.
    ///
    /// Antes esto hacía 5 llamadas (una por saga). Ahora es 1 sola llamada
    /// que trae todos los personajes, y de ahí nos quedamos solo con los
    /// que están en favoritos.
    @MainActor
    func getFavoriteCharactersModels() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let allCharacters = try await charactersService.getAllCheracters().items
            let favoriteIDs = Set(favoriteCharactersIDs.map { $0.characterID })
            favoriteCharacters = allCharacters
                .filter { favoriteIDs.contains($0.id) }
                .map { $0.toCharactersModel() }
        } catch {
            showError = true
            errorMessage = "No se pudieron cargar los personajes favoritos"
        }
    }

    /// Verifica si un personaje está en la lista de favoritos.
    @MainActor
    func checkIsFavorite(characterID: Int) async -> Bool {
        return favoriteCharactersIDs.contains(where: { $0.characterID == characterID })
    }

    /// Elimina un personaje de la lista de favoritos (de la memoria y de Firestore).
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
