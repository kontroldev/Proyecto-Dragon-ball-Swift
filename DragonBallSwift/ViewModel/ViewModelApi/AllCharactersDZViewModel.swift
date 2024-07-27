//
//  AllCharactersDZViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation
import Observation

@Observable
class AllCharactersDZViewModel{
    
    private let allCharactersDataService: AllCharactersDBDataService = AllCharactersDBDataService()
    var AllCharacters: [CharactersModel] = []
    var isLoading: Bool = false
    var showErrorMessage: Bool = false
    var errorMessage: String = ""
    var logo: String = "ZLogo"
    
    init () {
        Task {
            await getAllCharacters()
          
        }
    }
    
    @MainActor
    func getAllCharacters() async {
        do {
            AllCharacters = try await allCharactersDataService.getCharacters("dragonballz")
        }catch let error as NSError {
            print("Upss, ocurrio un error -> ",error.localizedDescription)
            errorMessage = "error al intentar optener los datos del servicio"
            showErrorMessage.toggle()
        }
    }

}
