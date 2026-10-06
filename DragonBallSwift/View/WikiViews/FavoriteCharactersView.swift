//
//  FavoriteCharactersView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 04-08-24.
//

import SwiftUI

struct FavoriteCharactersView: View {
    @Environment(FavoritesViewModel.self) private var favorites
    @Environment(SessionStore.self) private var session
    @Environment(\.dismiss) private var dismiss
    @State private var showsLogin = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if favorites.showError {
                    VStack(spacing: 8) {
                        Text(favorites.errorMessage)
                        Button("Reintentar") {
                            Task {
                                favorites.showError = false
                                await favorites.getFavoriteCharactersIDs()
                                await favorites.getFavoriteCharactersModels()
                            }
                        }
                    }.padding()
                }
                if session.userID == nil {
                    ContentUnavailableView {
                        Label("Tus favoritos", systemImage: "heart")
                    } description: {
                        Text("Inicia sesión para guardar y consultar tus personajes favoritos.")
                    } actions: {
                        Button("Iniciar sesión") { showsLogin = true }
                    }
                } else if favorites.favoriteCharacters.isEmpty && !favorites.isLoading {
                    ContentUnavailableView(
                        "Todavía no hay favoritos", systemImage: "heart",
                        description: Text("Guarda personajes desde la wiki."))
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(favorites.favoriteCharacters, id: \.id) { character in
                            VStack {
                                NavigationLink {
                                    SagasViewDetails(character: character, logoDB: .constant("DBLogo"))
                                } label: {
                                    BasicCharacterCardView(character: character, logo: "DBLogo")
                                }
                                Button("Quitar de favoritos") {
                                    Task {
                                        _ = await favorites.removeFromFavorites(characterID: character.id)
                                    }
                                }
                                .frame(minHeight: 44)
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .background(Color.backgroundColor)
            .navigationTitle("Favoritos")
            .overlay { if favorites.isLoading { ProgressView("Cargando favoritos…") } }
            .task(id: session.userID) {
                await favorites.getFavoriteCharactersIDs()
                await favorites.getFavoriteCharactersModels()
            }
            .refreshable {
                await favorites.getFavoriteCharactersIDs()
                await favorites.getFavoriteCharactersModels()
            }
            .toolbar { Button("Cerrar", systemImage: "xmark") { dismiss() } }
            .sheet(isPresented: $showsLogin) { LoginView() }
        }
    }
}

#Preview {
    FavoriteCharactersView().environment(FavoritesViewModel()).environment(SessionStore())
}
