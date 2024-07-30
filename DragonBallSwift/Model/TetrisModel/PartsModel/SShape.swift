//
//  SShape.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation
import SwiftUI

struct SShape: Shape {
    var color: Color{
        Color.purple
    }
    
    var occuppiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: -1),
        GridPosition(x: 5, y: -1),
        GridPosition(x: 4, y: 0, isPivot: true),
        GridPosition(x: 3, y: 0)
    ]
}
