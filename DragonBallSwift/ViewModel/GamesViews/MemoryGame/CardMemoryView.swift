//
//  CardMemoryView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

struct CardMemoryView: View {
    let cardMemory: CardMemoryModel
    let memoryViewModel: MemoryGameViewModel
    let width: Int

    var body: some View {
        Button {
            memoryViewModel.choose(cardMemory)
        } label: {
            Image(cardMemory.isFaceUp ? cardMemory.text : "klipartz")
                .resizable()
                .modifier(MemoryGameStyle())
        }
        .buttonStyle(.plain)
        .disabled(memoryViewModel.isResolving || memoryViewModel.gameOver(memoryViewModel.attempts))
        .accessibilityLabel(cardMemory.isFaceUp ? cardMemory.text : "Carta boca abajo")
        .accessibilityValue(
            memoryViewModel.matchedCards.contains(where: { $0.id == cardMemory.id })
                ? "Pareja encontrada" : "")
    }
}
