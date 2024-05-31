//
//  CardMemryModel.swift
//  DragonBallSwift
//
//  Created by EProyecto Dragon Ball on 30/5/24.
//

import Foundation
import Observation


@Observable
class CardMemoryModel: Identifiable {
    var id = UUID()
    var isFaceUp = false
    var isMctched = false
    var text: String
    
    init(text: String){
        self.text = text
    }
    
    func turnOver(){
        self.isFaceUp.toggle()
    }
}

// Matriz de cartas
let cardValue: [String] = [
    "GokuPeque", "Bulma", "cerdito", "Krilin", "Mutenroy", "Yamcha", "Tenshinhan", "Puar", "Karin", "drragon", "Chichi", "Chaoz"
 ]

func createCadList() ->  [CardMemoryModel] {
    // Crear una lista en blanco
    var cardList = [CardMemoryModel]()
    
    // Crea matrices dobles
    for cardValue in cardValue {
        cardList.append(CardMemoryModel(text: cardValue))
        cardList.append(CardMemoryModel(text: cardValue))
    }
    
    return cardList
}
