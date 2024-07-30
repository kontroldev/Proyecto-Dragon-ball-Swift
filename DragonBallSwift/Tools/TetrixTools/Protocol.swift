//
//  Protocol.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation
import SwiftUI

protocol Shape {
    var color: Color { get }
    var occuppiedPositions: [GridPosition] { get set }
    
    mutating func moveDown()
    mutating func moveUp()
    mutating func moveleft()
    mutating func moveRight()
    
    mutating func rotateRight()
    mutating func rotateLeft()
    
    func isInPosition( x: Int,  y: Int) -> Bool
}


protocol GridPositionProtocol {
    var x: Int { get set }
    var y: Int { get set }
    
    var isPivot: Bool { get set }
}
