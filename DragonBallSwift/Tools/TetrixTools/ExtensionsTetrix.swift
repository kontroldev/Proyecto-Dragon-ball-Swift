//
//  ExtensionsTetrix.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation
import SwiftUI

// Enumeración de tamaño de letras
enum FontSize: CGFloat {
    case s60 = 60
    case s38 = 38
    case s30 = 30
    case s24 = 24
    case s22 = 22
    case s20 = 20
    case s18 = 18
    case s16 = 16
    case s15 = 15
    case s12 = 12
    case small = 9
}

enum FontType: String {
    case light = "dsdigi"
    case regular = "Ds-Digital"
    case bold = "DS-Digital Bold"
    case digital = "Digital-7 Mono"
}

extension View {
    func font(size: FontSize, type: FontType) -> some View {
        return self.font(Font.custom(type.rawValue, size: size.rawValue))
    }
}

extension Shape{
    
    func isInPosition( x: Int, y: Int) -> Bool {
        return occuppiedPositions.first { item in
            item.x == x && item.y == y
        } != nil
    }
    
    
    
    mutating func moveDown(){
        for index in occuppiedPositions.indices {
            occuppiedPositions[index].y += 1
        }
    }
    
    mutating func moveUp(){
        for index in occuppiedPositions.indices {
            occuppiedPositions[index].y -= 1
        }
    }

    
    
    mutating func moveleft(){
        for index in occuppiedPositions.indices {
            occuppiedPositions[index].x -= 1
        }
    }
    
    mutating func moveRight(){
        for index in occuppiedPositions.indices {
            occuppiedPositions[index].x += 1
        }
    }
    
    
    mutating func rotateRight(){
        if let pivot = occuppiedPositions.first(where: { $0.isPivot == true}){
            
            let px = pivot.x
            let py = pivot.y
            
            for index in occuppiedPositions.indices {
                
                let x1 = occuppiedPositions[index].x
                let y1 = occuppiedPositions[index].y
                
                let x2 = (y1 + px - py)
                let y2 = (px + py - x1)
                
                occuppiedPositions[index].x = x2
                occuppiedPositions[index].y = y2
                
            }
        }
    }
    mutating func rotateLeft() {
        if let pivot = occuppiedPositions.first(where: { $0.isPivot == true}){
            
            let px = pivot.x
            let py = pivot.y
            
            for index in occuppiedPositions.indices {
                
                let x1 = occuppiedPositions[index].x
                let y1 = occuppiedPositions[index].y
                
                let x2 = (px + py - y1)
                let y2 = (x1 + py - px)
                
                occuppiedPositions[index].x = x2
                occuppiedPositions[index].y = y2
                
            }
        }
    }
}

