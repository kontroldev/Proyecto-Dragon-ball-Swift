//
//  SingleCharacterViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 1/8/24.
//

import Foundation
import Observation

@Observable
class SingleCharacterDbViewModel{
    private var singleCharacterDataServer: SingleCharacterServer = SingleCharacterServer()
    
    var character: SingleCharacterModel?
    var selectedCharacter: Character?
    var isLoading: Bool = false
    var isShowErrorMessage: Bool = false
    var errorMessage: String = ""
    
    
    @MainActor
    func getCharacterInformation(characterID id: String) async {
        do{
            character = try await singleCharacterDataServer.getSingleCharacter("dragonball", id: id)
            
            if let character = character{
                print("Se obtuvo la información del personaje: \(character.name)")
            }
        }catch{
            print(error)
            errorMessage = "Error al intentar obtener los datos del personaje desde el servidor"
            isShowErrorMessage.toggle()
        }
    }
}
