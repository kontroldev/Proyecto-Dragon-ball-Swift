//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct DragonBallView: View {
    @State private var viewModel: CharactersViewModel
    @Environment(FavoritesViewModel.self) private var favorites
    @State private var query = ""
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    init(referent: String, logo: String, sagas: String) {
        _viewModel = State(initialValue: CharactersViewModel(referent: referent, logo: logo, sagas: sagas))
    }

    var body: some View {
        ScrollView {
            if viewModel.showError && viewModel.characterModel.isEmpty {
                ContentUnavailableView {
                    Label("No se pudieron cargar los personajes", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(viewModel.errorMessage)
                } actions: {
                    Button("Reintentar") { Task { await viewModel.getCharacters() } }
                }
            } else if !viewModel.isLoading && viewModel.searchCharacters(characterName: query).isEmpty {
                ContentUnavailableView.search(text: query)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.searchCharacters(characterName: query), id: \.id) { character in
                        VStack(spacing: 0) {
                            NavigationLink {
                                SagasViewDetails(character: character, logoDB: .constant(viewModel.logo))
                            } label: {
                                BasicCharacterCardView(character: character, logo: viewModel.logo)
                            }
                            Button {
                                Task {
                                    if favorites.isFavorite(characterID: character.id) {
                                        _ = await favorites.removeFromFavorites(characterID: character.id)
                                    } else {
                                        await favorites.addToFavorites(characterID: character.id)
                                    }
                                }
                            } label: {
                                Label(
                                    favorites.isFavorite(characterID: character.id)
                                        ? "Quitar favorito" : "Guardar favorito",
                                    systemImage: favorites.isFavorite(characterID: character.id)
                                        ? "heart.fill" : "heart"
                                )
                                .font(.caption)
                                .frame(maxWidth: .infinity, minHeight: 44)
                            }
                            .accessibilityLabel("Favorito: \(character.name)")
                            .accessibilityValue(
                                favorites.isFavorite(characterID: character.id) ? "Guardado" : "Sin guardar")
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .background(Color.backgroundColor)
        .navigationTitle(viewModel.sagas)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "Busca un personaje")
        .overlay { if viewModel.isLoading { ProgressView("Cargando personajes…") } }
        .task { if viewModel.characterModel.isEmpty { await viewModel.getCharacters() } }
    }
}

#Preview {
    NavigationStack { DragonBallView(referent: "all", logo: "DBLogo", sagas: "Personajes") }
        .environment(FavoritesViewModel())
}
