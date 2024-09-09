//
//  WikiView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 24-07-24.
//

import SwiftUI

struct WikiView: View {
    
    let menuItem = [
        ItemMenu(name: "Dragon Ball", imegenName: "DBLogo", destination: AnyView(DragonBallView(referent: "dragonball", logo: "DBLogo", sagas: "Dragon Ball"))),
        ItemMenu(name: "Dragon Ball Z", imegenName: "ZLogo", destination: AnyView(DragonBallView(referent: "dragonballz", logo: "ZLogo", sagas: "Dragon Ball Z"))),
        ItemMenu(name: "Dragon Ball GT", imegenName: "GTLogo", destination: AnyView(DragonBallView(referent: "dragonballgt", logo: "GTLogo", sagas: "Dragon Ball GT"))),
        ItemMenu(name: "Dragon Ball Super", imegenName: "SuperLogo", destination: AnyView(DragonBallSView())),
        
        ItemMenu(name: "Dragones", imegenName: "LogoDragones", destination: AnyView(DragonBallView(referent: "dragons", logo: "LogoDragones", sagas: "Dragones")))
    ]
    
    @State private var showFavorites: Bool = false
    
    var body: some View {
        
        //Todo envuelto en un NavigationStack, para poder navegar a la vista seleccionada a través de un Navigation Link
        NavigationStack {
            VStack {
//                Text("Personajes")
//                    .font(.title)
//                    .foregroundStyle(.accent)
//                    .fontWeight(.bold)
                
                ScrollView {
                    ForEach(menuItem) { item in
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
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
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
            .navigationTitle("Sagas")
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .shadow(color: .white, radius:0.5)
            .toolbar {
                ToolbarItem {
                    Button {
                        showFavorites = true
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "heart.fill")
//                                .font(.footnote)
                            
//                            Text("Favoritos")
//                                .font(.caption2)
                        }
                    }
                }
            }
            .sheet(isPresented: $showFavorites) {
                FavoriteCharactersView()
            }
        }
    }
}

#Preview {
    WikiView()
}
