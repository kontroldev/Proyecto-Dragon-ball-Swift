//
//  TShape.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation
import SwiftUI

struct TShape: Shape {
    var color: Color{
        Color.green
    }
    
    var occuppiedPositions: [GridPosition] = [
        GridPosition(x: 4, y: 0),
        GridPosition(x: 3, y: -1),
        GridPosition(x: 4, y: -1, isPivot: true),
        GridPosition(x: 5, y: -1)
    ]
}
