//
//  ColorExtension { .swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import SwiftUI

extension Color {
    static let backgroundColor = Color("BackgroundColor")
    static let cardColor = Color("CardColor")
    
    
    static let backgroundColorEX = Color.init(red: 0.0249, green: 0.0627, blue: 0.2020)
    static let cardColorEX = Color.init(red: 42/255, green: 51/255, blue: 90/255)
    static let darkShadow = Color.init(red: 0.0549, green: 0.0627, blue: 0.1020)
    
    static let dipCircle = LinearGradient(gradient: Gradient(colors: [backgroundColorEX.opacity(0.3), darkShadow.opacity(0.3)]),
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
    
    static let dipCircle1 = LinearGradient(gradient: Gradient(colors: [backgroundColorEX, darkShadow]), 
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
}
