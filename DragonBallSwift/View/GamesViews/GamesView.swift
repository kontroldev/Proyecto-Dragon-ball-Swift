//
//  GamesView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import SwiftUI

struct GamesView: View {
    @State private var selectedGame: GameItemMenu?
    
    let menuItems = [
        GameItemMenu(name: .memoryGame, imegenName: "logoDBGM", destination: AnyView(MemoryGameView())),
        GameItemMenu(name: .tetrix, imegenName: "GokuTetrix", destination: AnyView(HomeTreixView()))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(menuItems) { item in
                        HStack {
                            Text(item.name.rawValue).font(.title2).bold()
                                .foregroundStyle(.accent)
                            
                            Spacer()
                            
                            Image(item.imegenName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                        }
                        .padding()
                        .background(Color("CardColor"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .onTapGesture {
                            selectedGame = item
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("Juegos")
            .fullScreenCover(item: $selectedGame) { game in
                game.destination
            }
        }
    }
}

#Preview {
    GamesView()
}
