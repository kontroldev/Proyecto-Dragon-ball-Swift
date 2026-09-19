//
//  CharactersViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//
//  La API anterior dejó de estar disponible. Este ViewModel consume ahora
//  dragonball-api.com y aplica localmente los filtros compatibles con su
//  JSON (afiliación y raza).

import Foundation
import Observation
import SwiftUI

@Observable
final class CharactersViewModel: @unchecked Sendable {

    private enum CatalogFilter {
        case all
        case affiliation(String)
        case race(String)

        init(identifier: String) {
            switch identifier {
            case "z-fighter":
                self = .affiliation("Z Fighter")
            case "villain":
                self = .affiliation("Villain")
            case "saiyan":
                self = .race("Saiyan")
            case "android":
                self = .race("Android")
            default:
                self = .all
            }
        }

        func apply(to characters: [Character]) -> [Character] {
            switch self {
            case .all:
                return characters
            case .affiliation(let affiliation):
                return characters.filter { $0.affiliation == affiliation }
            case .race(let race):
                return characters.filter { $0.race == race }
            }
        }
    }

    private let charactersService: AllCheractersProtocols
    private let catalogFilter: CatalogFilter

    var characterModel: [CharactersModel] = []
    var isLoading: Bool = false
    var showError: Bool = false
    var errorMessage: String = ""
    var sagas: String
    var referent: String
    var logo: String
    var work: Task<Void, Never>?
    // Columnas para el grid de la vista de listado
    let columns = [GridItem(), GridItem()]

    init(
        referent: String,
        logo: String,
        sagas: String,
        charactersService: AllCheractersProtocols = AllCheracteersService(
            networkClient: NetworkClient(urlSession: URLSession.shared)
        )
    ) {
        self.sagas = sagas
        self.logo = logo
        self.referent = referent
        self.catalogFilter = CatalogFilter(identifier: referent)
        self.charactersService = charactersService

        Task {
            await getCharacters()
        }
    }

    @MainActor
    func getCharacters() async {
        isLoading = true
        showError = false
        defer { isLoading = false }

        do {
            let characters = try await charactersService.getAllCheracters().items
            characterModel = catalogFilter
                .apply(to: characters)
                .map { $0.toCharactersModel() }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func searchCharacer(characterName: String) -> [CharactersModel] {
        let trimmed = characterName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return characterModel }
        return characterModel.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }
}
