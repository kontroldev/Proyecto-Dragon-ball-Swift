//
//  FavoritesViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 30-07-24.
//

import Foundation
import Observation

/// Publica escrituras confirmadas y descarta respuestas de sesiones anteriores.
@Observable
@MainActor
final class FavoritesViewModel {
    private let store: FavoriteCharacterStoring
    private let charactersService: CharacterCatalogProviding
    private var sessionRevision = 0
    private var pendingIDs: Set<Int> = []

    private(set) var favoriteCharactersIDs: [FavoriteCharacter] = []
    private(set) var favoriteCharacters: [CharactersModel] = []
    var isLoading = false
    var showError = false
    var errorMessage = ""

    init(
        charactersService: CharacterCatalogProviding = CharacterCatalogService(
            networkClient: NetworkClient(urlSession: URLSession.shared)),
        store: FavoriteCharacterStoring = APIFavoriteStore()
    ) {
        self.charactersService = charactersService
        self.store = store
    }

    func resetForSession() {
        sessionRevision += 1
        favoriteCharactersIDs = []
        favoriteCharacters = []
        pendingIDs = []
        showError = false
        errorMessage = ""
        isLoading = false
    }

    func isFavorite(characterID: Int) -> Bool {
        favoriteCharactersIDs.contains { $0.characterID == characterID }
    }

    func addToFavorites(characterID: Int) async {
        guard !isFavorite(characterID: characterID), !pendingIDs.contains(characterID) else { return }
        let revision = sessionRevision
        let userID = store.userID
        pendingIDs.insert(characterID)
        defer { if revision == sessionRevision { pendingIDs.remove(characterID) } }
        do {
            let character = FavoriteCharacter(characterID: characterID)
            try await store.addToFavorites(character: character)
            guard revision == sessionRevision, userID == store.userID else { return }
            favoriteCharactersIDs.append(character)
        } catch {
            guard revision == sessionRevision, userID == store.userID else { return }
            present(error)
        }
    }

    func getFavoriteCharactersIDs() async {
        guard store.userID != nil else { return }
        let revision = sessionRevision
        let userID = store.userID
        do {
            let favorites = try await store.getFavorites()
            guard revision == sessionRevision, userID == store.userID, !Task.isCancelled else { return }
            favoriteCharactersIDs = favorites
        } catch {
            guard revision == sessionRevision, userID == store.userID, !Task.isCancelled else { return }
            present(error)
        }
    }

    func getFavoriteCharactersModels() async {
        let revision = sessionRevision
        let userID = store.userID
        guard userID != nil else { return }
        isLoading = true
        defer { if revision == sessionRevision { isLoading = false } }
        do {
            let characters = try await charactersService.fetchCharacters().items
            guard revision == sessionRevision, userID == store.userID, !Task.isCancelled else { return }
            let ids = Set(favoriteCharactersIDs.map(\.characterID))
            favoriteCharacters = characters.filter { ids.contains($0.id) }.map { $0.toCharactersModel() }
        } catch {
            guard revision == sessionRevision, userID == store.userID, !Task.isCancelled else { return }
            present(error)
        }
    }

    func checkIsFavorite(characterID: Int) async -> Bool {
        isFavorite(characterID: characterID)
    }

    func removeFromFavorites(characterID: Int) async -> Bool {
        guard !pendingIDs.contains(characterID) else { return false }
        let revision = sessionRevision
        let userID = store.userID
        pendingIDs.insert(characterID)
        defer { if revision == sessionRevision { pendingIDs.remove(characterID) } }
        do {
            try await store.deleteFavoriteCharacter(characterID: characterID)
            guard revision == sessionRevision, userID == store.userID else { return false }
            favoriteCharactersIDs.removeAll { $0.characterID == characterID }
            favoriteCharacters.removeAll { $0.id == characterID }
            return true
        } catch {
            guard revision == sessionRevision, userID == store.userID else { return false }
            present(error)
            return false
        }
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
