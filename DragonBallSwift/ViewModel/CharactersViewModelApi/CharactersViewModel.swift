//
//  CharactersViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//
//  NOTA IMPORTANTE (para quien retome esto):
//  Este ViewModel es el que alimenta las pestañas por saga (Dragon Ball,
//  Dragon Ball Z, GT, Super, Dragones) y sigue usando la API de la
//  comunidad (la que montó Juan Pablo), a través de `getCharacters(_:)`.
//
//  No se ha migrado a dragonball-api.com como en Favoritos porque esa API
//  no separa los personajes por saga: los devuelve todos juntos en una
//  sola lista. Si en algún momento se quiere migrar esta parte también,
//  hay dos opciones:
//    1. Buscar otra API que sí separe por saga.
//    2. Cambiar el diseño de la Wiki para mostrar un único listado con
//       todos los personajes (usando AllCheracteersService, como en
//       Favoritos) en vez de pestañas separadas por saga.
//  De momento se deja tal cual, pero con el error gestionado de verdad
//  (antes solo se imprimía por consola y la UI no se enteraba de nada).

import Foundation
import Observation
import SwiftUI

@Observable
class CharactersViewModel: @unchecked Sendable, CheractersProtocols {

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

    init(referent: String, logo: String, sagas: String) {
        self.sagas = sagas
        self.logo = logo
        self.referent = referent

        // Carga inicial de los personajes de esta saga
        Task {
            isLoading = true
            await getCharacters()
            isLoading = false
        }
    }

    @MainActor
    func getCharacters() async {
        do {
            characterModel = try await getCharacters(referent)
        } catch {
            // Antes esto solo se imprimía por consola (print) y la pantalla
            // se quedaba vacía sin más explicación. Ahora se avisa de verdad.
            showError = true
            errorMessage = "No se pudieron cargar los personajes de \(sagas)"
        }
    }

    @MainActor
    func searchCharacer(characterName: String) -> [CharactersModel] {
        let trimmed = characterName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return characterModel }
        return characterModel.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }
}
