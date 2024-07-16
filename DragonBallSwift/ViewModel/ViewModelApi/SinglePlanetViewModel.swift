//
//  Single.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation
import Observation

/// ViewModel para manejar la lógica relacionada con la obtención de un solo planeta.
@Observable
class SinglePlanetViewModel {
    // Servicio para obtener los datos de un solo planeta.
    private let singlePlanetsService: SinglePlanetService = SinglePlanetService()
    
    var singlePlanet: SinglePlanet?     /// Datos del planeta obtenido.
    var isLoading: Bool = false         /// Flag para indicar si la carga está en curso.
    var showErrorMessage: Bool = false  /// Flag para indicar si se debe mostrar un mensaje de error.
    var errorMessage: String = ""       /// Mensaje de error.
    
    // Método para obtener los datos de un solo planeta.
    @MainActor
    func getSinglePlanet(planetID id: Int) async {
        do {
            // Intenta obtener los datos del planeta utilizando el servicio correspondiente.
            singlePlanet = try await singlePlanetsService.getSinglePlanet(id: id)
            
            // Si se obtienen los datos con éxito, imprime información del planeta en la consola.
            if let planet = singlePlanet {
                print("Se pbtuvo la información del planeta: \(planet) correctamente")
            }
            
        }catch {
            // En caso de error, actualiza el mensaje de error y muestra la bandera de mensaje de error.
            print(error)
            errorMessage = "Error al intentar obtener los datos del planeta desde el servidor"
            showErrorMessage.toggle()
        }
    }
}
