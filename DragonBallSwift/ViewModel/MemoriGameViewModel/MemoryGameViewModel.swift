//
//  MemoryGameViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import Observation
import SwiftUI

/// ViewModel para manejar la lógica relacionada con la memoria de juego.
@Observable
class MemoryGameViewModel{
    
    /// Definición de la cuadrícula para cuatro Filas
    var forColumGrid = [GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())]
    
    /// Definición de la cuadrícula para seis columnas.
    var sixColumGrid = [GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())]
    
 
    var cardMemoryModel: CardMemoryModel       /// Instancia de la clase Card.
    var matchedCards: [CardMemoryModel] = []   /// Lista de cartas emparejadas.
    var userChoices: [CardMemoryModel] = []    /// Lista de cartas elegidas por el usuario.
    
    // Constructor
    init(cardMemoryModel: CardMemoryModel = CardMemoryModel(text: "")) {
        self.cardMemoryModel = cardMemoryModel
    }
    
    /// Matriz de referencias de imágenes para las cartas.
    let cardValues: [String] = [
        "GokuPeque", "Bulma", "cerdito", "Krilin", "Mutenroy", "Yamcha", "Tenshinhan", "Puar", "Karin", "drragon", "Chichi", "Chaoz"
    ]
    
    /// Método para crear una lista de cartas duplicada.
    func createCardList() -> [CardMemoryModel] {
        var cardList = [CardMemoryModel]()
        
        /// Duplica cada valor de la matriz de referencias de imágenes y agrega una nueva carta para cada uno.
        for cardValue in cardValues {
            cardList.append(CardMemoryModel(text: cardValue))
            cardList.append(CardMemoryModel(text: cardValue))
        }
        
        return cardList
    }
    
    /// Método para verificar si hay coincidencia entre las cartas elegidas por el usuario.
     func checkForMatch() {
         /// Si el texto de las dos cartas elegidas es el mismo, se considera una coincidencia y se agregan a la lista de cartas emparejadas.
         if userChoices[0].text == userChoices[1].text {
             matchedCards.append(userChoices[0])
             matchedCards.append(userChoices[1])
         }
         
         /// Se limpia la lista de cartas elegidas por el usuario.
         userChoices.removeAll()
     }
    
}
