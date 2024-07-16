//
//  AllPlanetsViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation
import Observation

/// ViewModel para manejar la lógica relacionada con la obtención de todos los planetas.
@Observable
class AllPlanetsViewModel {
    // Servicio para obtener todos los planetas.
    private let allplanetsService: AllPlanetsService = AllPlanetsService()
    
    // Lista de todos los planetas obtenidos.
    var allPlanets: Planets?
    var isLoading: Bool = false        /// Flag para indicar si la carga está en curso.
    var showErrorMessage: Bool = false /// Flag para indicar si se debe mostrar un mensaje de error.
    var errorMessage: String = ""      /// Mensaje de error.
    
    // Constructor.
    init() {
        Task{
            await getAllPlanets()
        }
    }
    
    /// Obtiene todos los planetas de manera asíncrona.
    @MainActor
    func getAllPlanets() async {
        do {
            // Intenta obtener todos los planetas utilizando el servicio correspondiente.
            allPlanets = try await allplanetsService.getAllPlanets()
        }catch {
            // En caso de error, actualiza el mensaje de error y muestra la bandera de mensaje de error.
            print(error)
            errorMessage = "Error al intentar obtener datos de los planetas desde el servidor"
            showErrorMessage.toggle()
        }
    }
}
