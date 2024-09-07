//
//  AllCheractersViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation
import Observation

/// ViewModel para manejar la lógica relacionada con la obtención de todos los personajes.
@Observable
class AllCheractersViewModel {

    var allCheracters: [Character] = []      /// Lista de todos los personajes
    var searchedCharecters: [Character] = [] /// Lista de personajes buscados
    var isLoading: Bool = false              /// Flag para indicar si la carga está en curso
    var showErroMessege: Bool = false        /// Flag para indicar si se debe mostrar un mensaje de error
    var errorMessage: String = ""            /// Mensaje de error
    
    /// Servicio para obtener todos los personajes
    private let allCheracteersService: AllCheracteersService
    /// Constructor
    init(allCheracteersService: AllCheracteersService){
        self.allCheracteersService = allCheracteersService
        Task{
            await getAllCheracters()
        }
    }
    
    /// Obtine todo los caracteres y los almacena en la propiedad `allCheracters`
    @MainActor
    func getAllCheracters() async {
        do {
            allCheracters = try await allCheracteersService.getAllCheracters().items
        }catch {
            print(error)
            errorMessage = ""
            showErroMessege.toggle()
        }
    }
    
    
    /// Permite buscar un personaje por el nombre y lo guarda en la propiedad `searchedCharacters`
    func searchCharacters(characterName name: String){
        searchedCharecters = allCheracters.filter({$0.name.contains(name)})
    }
    
}
