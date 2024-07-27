//
//  AllDragonsViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import Foundation
import Observation

@Observable
class AllDragonsViewModel {
    
    private let allDragonsDataService: AllDragonsDataService = AllDragonsDataService()
    var AllDragos: [DragonsModel] = []
    var isLoading: Bool = false
    var showErrorMessage: Bool = false
    var errorMessage: String = ""
    var logo: String = "LogoDragones"
    
    init () {
        Task {
            await getAllDragons()
        }
    }
    
    @MainActor
    func getAllDragons() async {
        do {
            AllDragos = try await allDragonsDataService.getDragons()
        }catch let error as NSError {
            print("Upss, ocurrio un error -> ",error.localizedDescription)
            errorMessage = "error al intentar optener los datos del servicio"
            showErrorMessage.toggle()
        }
    }
}
