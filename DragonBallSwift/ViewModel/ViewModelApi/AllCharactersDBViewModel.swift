//
//  AllCharactersDBViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation
import Observation

@Observable
class AllCharactersDBViewModel{
    
    private let allCharactersDataService: AllCharactersDBDataService = AllCharactersDBDataService()
    var allCharacters: [CharactersModel] = []
    var isLoading: Bool = false
    var showErrorMessage: Bool = false
    var errorMessage: String = ""
    var logo: String = "DBLogo"

    init () {
        Task {
            await getAllCharacters()
          
        }
    }
    
    @MainActor
    func getAllCharacters() async {
        do {
            allCharacters = try await allCharactersDataService.getCharacters("dragonball")
        }catch let error as NSError {
            print("Upss, ocurrio un error -> ",error.localizedDescription)
            errorMessage = "error al intentar optener los datos del servicio"
            showErrorMessage.toggle()
        }
    }
    
    @MainActor
    func searchCharacer(characterName: String) -> [CharactersModel] {
        return allCharacters.filter { $0.name.contains(characterName) }
    }
}

