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
}
