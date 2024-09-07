//
//  SingleCharacterDZViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 2/8/24.
//

//import Foundation
//import Observation
//
//@Observable
//class SingleCharacterDZViewModel{
//    private var singleCharacterDataServer: SingleCharacterServer = SingleCharacterServer()
//    
//    var character: SingleCharacterModel?
//    var selectedCharacter: Character?
//    var isLoading: Bool = false
//    var isShowErrorMessage: Bool = false
//    var errorMessage: String = ""
//    
//    
//    @MainActor
//    func getCharacterInformation(characterID id: String) async {
//        do{
//            character = try await singleCharacterDataServer.getSingleCharacter("dragonballz", id: id)
//            
//            if let character = character{
//                print("Se obtuvo la información del personaje: \(character.name)")
//            }
//        }catch{
//            print(error)
//            errorMessage = "Error al intentar obtener los datos del personaje desde el servidor"
//            isShowErrorMessage.toggle()
//        }
//    }
//}
