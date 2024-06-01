//
//  SingileCheracterViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation
import Observation

/// ViewModel para manejar la lógica relacionada con la obtención de un solo personaje.
@Observable
class SingileCheracterViewModel{
    // Servicio para obtener los datos de un solo personaje.
    private let singleCheracterService: SingleCheracterService = SingleCheracterService()
    
    // Datos del personaje obtenido.
    var singlecheracter: SingleCharacter?
    var selectedCheracter: Character?  /// Personaje seleccionado (si es necesario).
    var isLoading: Bool = false        /// Flag para indicar si la carga está en curso.
    var showErrorMessage: Bool = false /// Flag para indicar si se debe mostrar un mensaje de error.
    var errorMessage: String = ""      /// Mesaje de error
    
    /// Método para obtener los datos de un solo personaje.
    @MainActor
    func getSingleCheracter(cheracterID id: Int) async {
        do {
            
            // Intenta obtener los datos del personaje utilizando el servicio correspondiente.
            singlecheracter = try await singleCheracterService.getSingleCherater(id: id)
            
            // Si se obtienen los datos con éxito, imprime el nombre del personaje en la consola.
            if let cheracter = singlecheracter {
                print("Se obtuvo la in formación del personaje: \(cheracter.name)")
            }
            
        }catch {
            // En caso de error, actualiza el mensaje de error y muestra la bandera de mensaje de error.
            print(error)
            errorMessage = "Error al intentar obtener los datos del personaje desde el servidor"
            showErrorMessage.toggle()
        }
    }
}
