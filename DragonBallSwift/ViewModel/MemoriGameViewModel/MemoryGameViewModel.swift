//
//  MemoryGameViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import Observation
import SwiftUI

enum Difficulty {
    case level_1
    case level_2
    case level_3
}

@Observable
@MainActor
final class MemoryGameViewModel {
    var score = 0
    var attempts = 0
    var completedScreens = 0
    var cardList: [CardMemoryModel] = []
    var difficulty: Difficulty = .level_1
    var matchedCards: [CardMemoryModel] = []
    var userChoices: [CardMemoryModel] = []
    private(set) var isResolving = false
    private(set) var remainingTime = 60
    private var revealTask: Task<Void, Never>?
    private var countdownTask: Task<Void, Never>?

    let forColumGrid = Array(repeating: GridItem(.flexible()), count: 4)
    let sixColumGrid = Array(repeating: GridItem(.flexible()), count: 6)
    let cardValues = [
        "GokuPeque", "Bulma", "cerdito", "Krilin", "Mutenroy", "Yamcha",
        "Tenshinhan", "Puar", "Karin", "drragon", "Chichi", "Chaoz",
    ]

    func createCardList() -> [CardMemoryModel] {
        cardValues.flatMap { [CardMemoryModel(text: $0), CardMemoryModel(text: $0)] }
    }

    func isRoundComplete() -> Bool {
        !cardList.isEmpty && matchedCards.count == cardList.count
    }

    /// Bloquea selecciones mientras se muestran las dos cartas elegidas.
    func choose(_ card: CardMemoryModel) {
        guard !isResolving, !gameOver(attempts), !card.isFaceUp,
            cardList.contains(where: { $0.id == card.id }),
            !matchedCards.contains(where: { $0.id == card.id })
        else { return }
        card.isFaceUp = true
        userChoices.append(card)
        guard userChoices.count == 2 else { return }
        isResolving = true
        revealTask = Task { [weak self] in
            do { try await Task.sleep(for: .milliseconds(800)) } catch { return }
            self?.checkForMatch()
        }
    }

    func checkForMatch() {
        guard userChoices.count == 2 else { return }
        if userChoices[0].text == userChoices[1].text {
            matchedCards += userChoices
            score += 5
        } else {
            userChoices.forEach { $0.isFaceUp = false }
            score = max(0, score - 1)
            attempts += 1
        }
        userChoices = []
        isResolving = false
        if isRoundComplete() {
            completedScreens += 1
            countdownTask?.cancel()
        }
    }

    func resetGameAll(cardList: [CardMemoryModel], difficulty: Difficulty = .level_1) {
        score = 0
        completedScreens = 0
        self.difficulty = difficulty
        startRound(cards: cardList)
    }

    func nextRound() {
        updateDifficulty()
        startRound(cards: createCardList())
    }

    private func startRound(cards: [CardMemoryModel]) {
        pauseTimers()
        cards.forEach { $0.isFaceUp = false }
        cardList = cards.shuffled()
        matchedCards = []
        userChoices = []
        attempts = 0
        remainingTime = 60
        isResolving = false
        resumeTimers()
    }

    func updateDifficulty() {
        difficulty = completedScreens >= 4 ? .level_3 : completedScreens >= 2 ? .level_2 : .level_1
    }

    func gameOver(_ attempts: Int) -> Bool {
        (difficulty != .level_1 && attempts >= 10) || (difficulty == .level_3 && remainingTime == 0)
    }

    func pauseTimers() {
        revealTask?.cancel()
        countdownTask?.cancel()
        // Al suspender la partida, ninguna selección debe bloquear el tablero.
        userChoices.forEach { $0.isFaceUp = false }
        userChoices = []
        isResolving = false
    }

    func resumeTimers() {
        countdownTask?.cancel()
        guard difficulty == .level_3, !isRoundComplete(), !gameOver(attempts) else { return }
        countdownTask = Task { [weak self] in
            while !Task.isCancelled {
                do { try await Task.sleep(for: .seconds(1)) } catch { return }
                guard let self, self.remainingTime > 0 else { return }
                self.remainingTime -= 1
            }
        }
    }
}
