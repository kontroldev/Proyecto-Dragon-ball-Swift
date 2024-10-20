//
//  CardTransformationView.swift
//  DragonBallSwift
//
//  Created by Esteban Pérez Castillejo on 8/10/24.
//

import SwiftUI

struct CardTransformationView: View {
    @Namespace private var animation
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack{
            CaedContent(animation: animation, isExpanded: $isExpanded)
                .frame(width: isExpanded ? UIScreen.main.bounds.width * 0.9 : 140,
                       height: isExpanded ? UIScreen.main.bounds.height * 0.7 : 60) // Ajuste de tamaño
                .background(LinearGradient(
                    gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .cornerRadius(16)
                .shadow(radius: isExpanded ? 30 : 10) // Sombra dinámica
                .scaleEffect(isExpanded ? 1.0 : 0.95) // Efecto de zoom
                .matchedGeometryEffect(id: "card", in: animation) // Animación fluida
                .animation(.smooth(duration: 0.45), value: isExpanded)
                .onTapGesture {
                    // Expansión y contracción
                    withAnimation(.smooth(duration: 0.45)) {
                        isExpanded.toggle()
                    }
                }
                .offset(x: isExpanded ? 0 : 100, y: isExpanded ? 0 : 125)
        }
        .zIndex(1)
        
    }
}

#Preview {
    @Previewable @State var mock = Mocks()
    
    @Previewable @State var logoDB = "DBLogo"


        return SagasViewDetails(character: mock.character, logoDB: $logoDB)
    
}
