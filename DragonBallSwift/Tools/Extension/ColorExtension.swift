//
//  ColorExtension { .swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import SwiftUI

//extension Color {
//    static let backgroundColor = Color("BackgroundColor")
//    static let cardColor = Color("CardColor")
//    
//    
//    static let backgroundColorEX = Color.init(red: 0.0249, green: 0.0627, blue: 0.2020)
//    static let cardColorEX = Color.init(red: 42/255, green: 51/255, blue: 90/255)
//    static let darkShadow = Color.init(red: 0.0549, green: 0.0627, blue: 0.1020)
//    
//    static let dipCircle = LinearGradient(gradient: Gradient(colors: [backgroundColorEX.opacity(0.3), darkShadow.opacity(0.3)]),
//                                          startPoint: .topLeading,
//                                          endPoint: .bottomTrailing)
//    
//    static let dipCircle1 = LinearGradient(gradient: Gradient(colors: [backgroundColorEX, darkShadow]), 
//                                           startPoint: .topLeading,
//                                           endPoint: .bottomTrailing)
//}


// Con Blanco en modo claro

//extension Color {
//    // Uso de colores dinámicos según el modo de color actual
//    static var backgroundColor: Color {
//        Color.dynamicColor(light: Color.white, dark: Color("BackgroundColor"))
//    }
//    
//    static var cardColor: Color {
//        Color.dynamicColor(light: Color(red: 230/255, green: 230/255, blue: 250/255), dark: Color("CardColor"))
//    }
//    
//    // Definición personalizada de colores RGB para modo claro/oscuro
//    static var backgroundColorEX: Color {
//        Color.dynamicColor(light: Color(red: 0.85, green: 0.88, blue: 0.95), dark: Color(red: 0.0249, green: 0.0627, blue: 0.2020))
//    }
//    
//    static var cardColorEX: Color {
//        Color.dynamicColor(light: Color(red: 180/255, green: 190/255, blue: 230/255), dark: Color(red: 42/255, green: 51/255, blue: 90/255))
//    }
//    
//    static var darkShadow: Color {
//        Color.dynamicColor(light: Color(red: 0.85, green: 0.85, blue: 0.90), dark: Color(red: 0.0549, green: 0.0627, blue: 0.1020))
//    }
//    
//    static var dipCircle: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX.opacity(0.3),
//            darkShadow.opacity(0.3)
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    static var dipCircle1: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX,
//            darkShadow
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    // Función auxiliar para manejar dinámicamente los colores claros y oscuros
//    static func dynamicColor(light: Color, dark: Color) -> Color {
//        return Color(UIColor { traitCollection in
//            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
//        })
//    }
//}

// Con Celeste en modo claro

//extension Color {
//    // Uso de colores dinámicos según el modo de color actual
//    static var backgroundColor: Color {
//        Color.dynamicColor(light: Color(red: 0.678, green: 0.847, blue: 0.902), dark: Color("BackgroundColor"))
//    }
//    
//    static var cardColor: Color {
//        Color.dynamicColor(light: Color(red: 230/255, green: 230/255, blue: 250/255), dark: Color("CardColor"))
//    }
//    
//    // Definición personalizada de colores RGB para modo claro/oscuro
//    static var backgroundColorEX: Color {
//        Color.dynamicColor(light: Color(red: 0.678, green: 0.847, blue: 0.902), dark: Color(red: 0.0249, green: 0.0627, blue: 0.2020))
//    }
//    
//    static var cardColorEX: Color {
//        Color.dynamicColor(light: Color(red: 180/255, green: 190/255, blue: 230/255), dark: Color(red: 42/255, green: 51/255, blue: 90/255))
//    }
//    
//    static var darkShadow: Color {
//        Color.dynamicColor(light: Color(red: 0.85, green: 0.85, blue: 0.90), dark: Color(red: 0.0549, green: 0.0627, blue: 0.1020))
//    }
//    
//    static var dipCircle: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX.opacity(0.3),
//            darkShadow.opacity(0.3)
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    static var dipCircle1: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX,
//            darkShadow
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    // Función auxiliar para manejar dinámicamente los colores claros y oscuros
//    static func dynamicColor(light: Color, dark: Color) -> Color {
//        return Color(UIColor { traitCollection in
//            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
//        })
//    }
//}

// Con naramja en modo claro

extension Color {
    // Uso de colores dinámicos según el modo de color actual
    static var backgroundColor: Color {
        Color.dynamicColor(light: Color(red: 0.8, green: 0.6, blue: 0.4), dark: Color("BackgroundColor"))
    }
    
    
    static var cardColor: Color {
        Color.dynamicColor(light: Color(red: 0.85, green: 0.75, blue: 0.65), dark: Color("CardColor"))
    }
    
    static var textColor: Color {
        Color.dynamicColor(light: Color(red: 0.4, green: 0.3, blue: 0.2), dark: Color(red: 0.85, green: 0.85, blue: 0.9))
    }

    // Definición personalizada de colores RGB para modo claro/oscuro
    static var backgroundColorEX: Color {
        Color.dynamicColor(light: Color(red: 1.0, green: 0.8, blue: 0.6), dark: Color(red: 0.0249, green: 0.0627, blue: 0.2020))
    }
    
    static var cardColorEX: Color {
        Color.dynamicColor(light: Color(red: 1.0, green: 0.9, blue: 0.8), dark: Color(red: 42/255, green: 51/255, blue: 90/255))
    }
    
    static var darkShadow: Color {
        Color.dynamicColor(light: Color(red: 0.9, green: 0.9, blue: 0.9), dark: Color(red: 0.0549, green: 0.0627, blue: 0.1020))
    }
    
    static var dipCircle: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [
            backgroundColorEX.opacity(0.3),
            darkShadow.opacity(0.3)
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static var dipCircle1: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [
            backgroundColorEX,
            darkShadow
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // Función auxiliar para manejar dinámicamente los colores claros y oscuros
    static func dynamicColor(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// Con Purpura en modo claro

//extension Color {
//    // Uso de colores dinámicos según el modo de color actual
//    static var backgroundColor: Color {
//        Color.dynamicColor(light: Color(red: 0.8, green: 0.7, blue: 1.0), dark: Color("BackgroundColor"))
//    }
//    
//    static var cardColor: Color {
//        Color.dynamicColor(light: Color(red: 0.9, green: 0.8, blue: 1.0), dark: Color("CardColor"))
//    }
//    
//    // Definición personalizada de colores RGB para modo claro/oscuro
//    static var backgroundColorEX: Color {
//        Color.dynamicColor(light: Color(red: 0.8, green: 0.7, blue: 1.0), dark: Color(red: 0.0249, green: 0.0627, blue: 0.2020))
//    }
//    
//    static var cardColorEX: Color {
//        Color.dynamicColor(light: Color(red: 0.9, green: 0.8, blue: 1.0), dark: Color(red: 42/255, green: 51/255, blue: 90/255))
//    }
//    
//    static var darkShadow: Color {
//        Color.dynamicColor(light: Color(red: 0.9, green: 0.9, blue: 0.95), dark: Color(red: 0.0549, green: 0.0627, blue: 0.1020))
//    }
//    
//    static var dipCircle: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX.opacity(0.3),
//            darkShadow.opacity(0.3)
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    static var dipCircle1: LinearGradient {
//        LinearGradient(gradient: Gradient(colors: [
//            backgroundColorEX,
//            darkShadow
//        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    }
//
//    // Función auxiliar para manejar dinámicamente los colores claros y oscuros
//    static func dynamicColor(light: Color, dark: Color) -> Color {
//        return Color(UIColor { traitCollection in
//            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
//        })
//    }
//}
