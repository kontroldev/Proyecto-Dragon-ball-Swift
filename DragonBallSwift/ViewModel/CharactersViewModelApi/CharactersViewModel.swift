//
//  CharactersViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class CharactersViewModel {
    private let charactersServer: CharactersService = CharactersService()
    
    
    var characterModel: [CharactersModel] = []
    var isLoading: Bool = false
    var referent: String
    var logo: String
    
    // Define las columnas dentro delña vistas de listados
    let columns = [GridItem(), GridItem()]
    
    init(referent: String, logo: String) {
        self.logo = logo
        self.referent = referent
        
        
        // Llamada inicial para cargar personajes del modelo especificado
        Task {
            isLoading = true
            await getCharacters()
            isLoading = false
        }
    }
    
    
    @MainActor
    func getCharacters() async {
        do {
            characterModel = try await charactersServer.getCharacters(referent)
        } catch {
            print("Upss, Ocurrió un error ->", error.localizedDescription)
        }
    }
    
    
    @MainActor
    func searchCharacer(characterName: String) -> [CharactersModel] {
        return characterModel.filter { $0.name.contains(characterName) }
    }
}
