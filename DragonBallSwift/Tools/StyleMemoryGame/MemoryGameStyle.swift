//
//  MemoryGameStyle.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/5/24.
//

import Foundation
import SwiftUI

// Modificador personalizado de las cartas
struct MemoryGameStyle: ViewModifier {
    
    let width: Int = 80
    
    func body(content: Content) -> some View {
        content
            .frame(width: CGFloat(width), height: CGFloat(width))
            .background(Color(red: 0.68, green: 0.83, blue: 0.96))
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.18, green: 6.2, blue: 1.6), lineWidth: 3)
            }
    }
}
