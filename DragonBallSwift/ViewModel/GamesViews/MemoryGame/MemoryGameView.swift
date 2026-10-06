//
//  MemoryGameView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

struct MemoryGameView: View {
    @State var memoryViewModel = MemoryGameViewModel()

    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(
                    colors: [Color("BackgroundColor"), Color.backgroundColorEX], center: .center,
                    startRadius: 30, endRadius: 380
                )
                .ignoresSafeArea()
                ScrollView {
                    VStack {
                        VStack {
                            LazyVGrid(columns: memoryViewModel.forColumGrid, spacing: 15) {
                                ForEach(memoryViewModel.cardList) { card in
                                    CardMemoryView(
                                        cardMemory: card,
                                        memoryViewModel: memoryViewModel,
                                        width: 70)
                                }
                            }

                            if memoryViewModel.isRoundComplete() {
                                Button("Siguiente ronda") { memoryViewModel.nextRound() }
                            }
                            if memoryViewModel.difficulty == .level_3 {
                                Text("Tiempo: \(memoryViewModel.remainingTime) s")
                            }
                            VStack {
                                Text("Encuentra todas las parejas").font(.system(size: 12).bold())

                                LazyVGrid(columns: memoryViewModel.sixColumGrid, spacing: 5) {

                                    ForEach(memoryViewModel.cardValues, id: \.self) { cardValue in

                                        if !memoryViewModel.matchedCards.contains(where: {
                                            $0.text == cardValue
                                        }) {
                                            Image(cardValue).resizable()
                                                .frame(width: 30, height: 30)
                                                .shadow(color: .blue, radius: 3)

                                        }
                                    }

                                }
                            }
                            .modifier(MemoryBacgroundSingle())

                        }
                    }.padding(9)
                }
                if memoryViewModel.gameOver(memoryViewModel.attempts) {
                    GameOverMGView(memoryViewModel: memoryViewModel)
                }

            }

            .onAppear {
                if memoryViewModel.cardList.isEmpty {
                    memoryViewModel.resetGameAll(cardList: memoryViewModel.createCardList())
                } else {
                    memoryViewModel.resumeTimers()
                }
            }
            .onDisappear { memoryViewModel.pauseTimers() }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { memoryViewModel.resumeTimers() } else { memoryViewModel.pauseTimers() }
            }
            .toolbar {
                ToolbarItem(
                    placement: .bottomBar,
                    content: {
                        Button(
                            action: {
                                memoryViewModel.resetGameAll(cardList: memoryViewModel.cardList)
                            },
                            label: {
                                VStack {
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .foregroundStyle(.red)
                                        .font(.title)
                                        .fontWeight(.black)

                                    Text("Reiniciar")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                            }
                        )
                        .padding(.top, 12)

                    })

                ToolbarItem(
                    placement: .automatic,
                    content: {

                        Text("Puntuación: \(memoryViewModel.score)")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(Color.accentColor)
                    })

                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()

                            Text("Volver")
                                .font(.callout)
                        }
                    }

                }
            }

        }
    }
}

#Preview {
    return MemoryGameView()
}
