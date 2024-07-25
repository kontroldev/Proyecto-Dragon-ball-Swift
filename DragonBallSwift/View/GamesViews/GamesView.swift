//
//  GamesView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import SwiftUI

struct GamesView: View {
    
    let menuItems = [
        ItemMenu(name: "Memory game", imegenName: "logoDBGM", destination: AnyView(MemoryGameView())),
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
                        NavigationLink(destination: item.destination) {
                            HStack {
                                Text(item.name).font(.title3).bold()
                                    .foregroundStyle(.accent)
                                
                                Spacer()
                                
                                Image(item.imegenName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color("BackgroundColor"))
        }
    }
}

#Preview {
    GamesView()
}
