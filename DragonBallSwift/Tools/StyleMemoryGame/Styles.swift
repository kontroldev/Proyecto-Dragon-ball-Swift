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
            .background(Color(red: 0.68, green: 0.83, blue: 0.96)) // Establece el color de fondo de la carta.
            .clipShape(.rect(cornerRadius: 10)) // Da forma rectangular a la carta con esquinas redondeadas.
            .overlay { // Agrega un borde a la carta.
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.18, green: 6.2, blue: 1.6), lineWidth: 3) // Define el grosor y color del borde.
            }
    }
}

/// Modificador de vista para el fondo de una sección del juego de memoria.
struct MemoryBacgroundSingle: ViewModifier{
    // Aplica el estilo a la vista de contenido.
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible.
            .background(.regularMaterial) // Establece el color de fondo de la sección.
            .clipShape(.rect(cornerRadius: 20)) // Da forma rectangular a la sección con esquinas redondeadas.
            .padding(.horizontal, 20) // Agrega relleno orizontal
            .padding(.top, 6) // Agrega relleno superior.
    }
}
