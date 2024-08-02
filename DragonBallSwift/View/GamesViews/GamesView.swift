//
//  GamesView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import SwiftUI

struct GamesView: View {
    
    @State private var isAnElementTapped: Bool = false
    @State private var selectedGame: GameNames = .memoryGame
    
    let menuItems = [
        GameItemMenu(name: .memoryGame, imegenName: "logoDBGM", destination: AnyView(MemoryGameView(dismiss: .constant(false)))),
        GameItemMenu(name: .tetrix, imegenName: "GokuTetrix", destination: AnyView(HomeTreixView(dismiss: .constant(false))))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Juegos")
                    .font(.title)
                    .foregroundStyle(.accent)
                    .fontWeight(.bold)
                
                ScrollView {
                    ForEach(menuItems) { item in
                        HStack {
                            Text(item.name.rawValue).font(.title2).bold()
                                .foregroundStyle(.accent)
                            
                            Spacer()
                            
                            Image(item.imegenName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
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
                            isAnElementTapped = true
                            selectedGame = item.name
                        }
                        .fullScreenCover(isPresented: $isAnElementTapped) {
                            switch selectedGame {
                            case .memoryGame:
                                MemoryGameView(dismiss: $isAnElementTapped)
                            case .tetrix:
                                HomeTreixView(dismiss: $isAnElementTapped)
                            }
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .onAppear(perform: {
                print(selectedGame)
            })
        }
    }
}

#Preview {
    GamesView()
}
