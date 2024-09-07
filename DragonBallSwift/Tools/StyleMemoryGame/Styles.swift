//
//  Styles.swift
//  MemoriGame
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import SwiftUI

/// Modificador de vista para el estilo de las cartas del juego de memoria.
struct MemoryGameStyle: ViewModifier {
    
    let width: Int = 80  // Ancho de las cartas.
    
    // Aplica el estilo a la vista de contenido.
    func body(content: Content) -> some View {
        content
            .frame(width: CGFloat(width), height: CGFloat(width)) // Define el tamaño de la carta.
            .background(LinearGradient(
                gradient: Gradient(colors: [.cardColorEX, .blue]),
                startPoint: .top,
                endPoint: .bottom
            )) // Establece el color de fondo de la carta.
            .clipShape(.rect(cornerRadius: 10)) // Da forma rectangular a la carta con esquinas redondeadas.
            .overlay { // Agrega un borde a la carta.
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1) // Define el grosor y color del borde.
                    
            }
    }
}

/// Modificador de vista para el fondo de una sección del juego de memoria.
struct MemoryBacgroundSingle: ViewModifier{
    // Aplica el estilo a la vista de contenido.
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible.
            .background(LinearGradient(
                gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                startPoint: .top,
                endPoint: .bottom
            )) // Establece el color de fondo de la sección.
            .clipShape(.rect(cornerRadius: 7))// Da forma rectangular a la sección con esquinas redondeadas.
            .shadow(color: .white, radius: 2)
            .padding(.horizontal, 20) // Agrega relleno orizontal
            .padding(.top, 8) // Agrega relleno superior.
    }
}

#Preview {
    return MemoryGameView()
}
