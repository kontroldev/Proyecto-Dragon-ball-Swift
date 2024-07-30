//
//  GridPosition.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation

// Modelo de posición de piezas
struct GridPosition: GridPositionProtocol{
    var x: Int = -1
    var y: Int = -1
    var isPivot: Bool = false
}
