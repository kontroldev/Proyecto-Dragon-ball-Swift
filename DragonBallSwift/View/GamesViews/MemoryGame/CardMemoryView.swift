//
//  CardMemoryView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

/// Vista de una carta en el juego de memoria.
struct CardMemoryView: View {
    @State var cardMemory: CardMemoryModel
    @State var memoryViewModel: MemoryGameViewModel
    
    let width: Int // Ancho de la carta.
    
    var body: some View {
        /// Verifica si la carta está boca arriba o si ya ha sido emparejada.
        if cardMemory.isFaceUp || memoryViewModel.matchedCards.contains(where: {$0.id == cardMemory.id}){
            /// Muestra la imagen de la carta si está boca arriba o si ya ha sido emparejada.
            Image(cardMemory.text).resizable()
                .modifier(MemoryGameStyle())
            
        } else {
            /// Muestra el reverso de la carta si está boca abajo y no ha sido emparejada.
            Image("klipartz").resizable()
                .modifier(MemoryGameStyle())
                .onTapGesture {
                    // Maneja el tap gesture en la carta.
                    if memoryViewModel.userChoices.count == 0 {
                        // Voltea la carta si no hay otra carta seleccionada.
                        cardMemory.isFaceUp.toggle()
                        memoryViewModel.userChoices.append(cardMemory)
                        
                    } else if memoryViewModel.userChoices.count == 1 {
                        /// Voltea la carta si ya hay una carta seleccionada y verifica si hay coincidencia después de un tiempo.
                        cardMemory.isFaceUp.toggle()
                        memoryViewModel.userChoices.append(cardMemory)
                        /// Realiza una animación de volteo de las cartas seleccionadas después de un tiempo.
                        withAnimation(Animation.linear.delay(1)){
                            for thisCar in memoryViewModel.userChoices{
                                thisCar.isFaceUp.toggle()
                            }
                        }
                        /// Verifica si hay coincidencia entre las cartas seleccionadas.
                        memoryViewModel.checkForMatch()
                    }
                }
        }
    }
}

