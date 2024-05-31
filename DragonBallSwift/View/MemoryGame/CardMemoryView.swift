//
//  CardMemoryView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

struct CardMemoryView: View {
    @State var cardMemory: CardMemoryModel
    
    @Binding var matchedCards: [CardMemoryModel]
    @Binding var userChoises: [CardMemoryModel]
    
    let width: Int
    
    var body: some View {
        if cardMemory.isFaceUp || matchedCards.contains(where: {$0.id == cardMemory.id}){
            Image(cardMemory.text).resizable()
                .modifier(MemoryGameStyle())
        } else {
            Image("klipartz").resizable()
                .modifier(MemoryGameStyle())
                .onTapGesture {
                    if userChoises.count == 0 {
                        cardMemory.turnOver()
                        userChoises.append(cardMemory)
                    } else if userChoises.count == 1 {
                        cardMemory.turnOver()
                        userChoises.append(cardMemory)
                        withAnimation(Animation.linear.delay(1)){
                            for thisCar in userChoises{
                                thisCar.turnOver()
                            }
                        }
                        checkForMatch()
                    }
                }
        }
    }
    
    func checkForMatch(){
        if userChoises[0].text == userChoises[1].text {
            matchedCards.append(userChoises[0])
            matchedCards.append(userChoises[1])
        }
        
        userChoises.removeAll()
    }
    
}

