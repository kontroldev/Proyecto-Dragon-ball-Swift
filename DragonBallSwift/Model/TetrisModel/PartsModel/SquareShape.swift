//
//  SquareShape.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct SquareShape: Shape{
    var color: Color {
        Color.yellow
    }
    
    var occuppiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: -1),
        GridPosition(x: 5, y: -1),
        GridPosition(x: 4, y: 0),
        GridPosition(x: 5, y: 0)
    ]
}
