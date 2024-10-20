//
//  CaedContent.swift
//  DragonBallSwift
//
//  Created by Esteban Pérez Castillejo on 8/10/24.
//

import SwiftUI

struct CaedContent: View {
    var animation: Namespace.ID // Recibe el espacio de animación
    @Binding var isExpanded: Bool // Controla el estado expandido de la tarjeta
    @State private var selectedImageIndex: Int = 0 // Controla la imagen seleccionada
    
    // Datos para las imágenes y descripciones
    let images = ["star.fill", "moon.fill", "cloud.fill"]
    let descriptions = [
        "Esta es la descripción para la imagen de la estrella.",
        "Esta es la descripción para la imagen de la luna.",
        "Esta es la descripción para la imagen de la nube."
    ]
    
    var body: some View {
        VStack{
            if isExpanded{
                // Vista de la tarjeta Expandida
            } else {
                // Vista de la tarjeta contraída
                VStack{
                    Image(.iconoT).resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.cardColorEX, radius: 10)
                        .matchedGeometryEffect(id: "titulo", in: animation) // Animación suave del título
                }
                .padding()

            }
        }
    }
}

#Preview {
    CardTransformationView()
}
