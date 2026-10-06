//
//  CardMemryModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import Foundation
import Observation

@Observable
class CardMemoryModel: Identifiable {
    var id = UUID()
    var isFaceUp = false
    var isMatched = false
    var text: String

    init(text: String) {
        self.text = text
    }
}
