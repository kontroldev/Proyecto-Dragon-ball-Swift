//
//  WikiView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 24-07-24.
//

import SwiftUI

struct WikiView: View {

    let menuItem = [
        ItemMenu(
            name: "Todos los personajes", imegenName: "DBLogo",
            destination: AnyView(DragonBallView(referent: "all", logo: "DBLogo", sagas: "Personajes"))),
        ItemMenu(
            name: "Guerreros Z", imegenName: "ZLogo",
            destination: AnyView(DragonBallView(referent: "z-fighter", logo: "ZLogo", sagas: "Guerreros Z"))),
        ItemMenu(
            name: "Villanos", imegenName: "GTLogo",
            destination: AnyView(DragonBallView(referent: "villain", logo: "GTLogo", sagas: "Villanos"))),
        ItemMenu(
            name: "Saiyans", imegenName: "SuperLogo",
            destination: AnyView(DragonBallView(referent: "saiyan", logo: "SuperLogo", sagas: "Saiyans"))),
        ItemMenu(
            name: "Androides", imegenName: "LogoDragones",
            destination: AnyView(
                DragonBallView(referent: "android", logo: "LogoDragones", sagas: "Androides"))),
    ]

    @State private var showFavorites: Bool = false

    var body: some View {

        NavigationStack {
            VStack {

                ScrollView {
                    ForEach(menuItem) { item in
                        NavigationLink(destination: item.destination) {
                            HStack {
                                Text(item.name).font(.title3).bold()
                                    .foregroundStyle(Color.textColor)

                                Spacer()

                                Image(item.imegenName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
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
            .navigationTitle("Personajes")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .white, radius: 0.5)
            .toolbar {
                ToolbarItem {
                    Button {
                        showFavorites = true
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "heart.fill").foregroundStyle(Color.textColor)

                        }
                    }
                    .accessibilityLabel("Abrir favoritos")
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
