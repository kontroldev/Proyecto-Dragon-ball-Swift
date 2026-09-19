//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct DragonBallView: View {
    //Estados para obtener los personajes de la API
    @State private var viewModel: CharactersViewModel
    
    init(referent: String, logo: String, sagas: String){
        _viewModel = State(initialValue: CharactersViewModel(referent: referent, logo: logo, sagas: sagas))
    }
    
    @State private var isLoading = false
    
    //Estados para manejar los personajes favoritos
    @Environment(FavoritesViewModel.self) var favoritesViewModel
    @State private var deleteCharacterFromFavorites: Bool = false
    
    //Estados para búsqueda de personajes
    @State private var isSearching: Bool = false
    @FocusState private var searchBarFocus: Bool
    @State private var searchedCharacters: [CharactersModel] = []
    @State private var characterName: String = ""
    
    let columns = [GridItem(), GridItem()]

    private var displayedCharacters: [CharactersModel] {
        characterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? viewModel.characterModel
            : searchedCharacters
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.showError && viewModel.characterModel.isEmpty {
                    ContentUnavailableView {
                        Label("No se pudieron cargar las cartas", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(viewModel.errorMessage)
                    } actions: {
                        Button("Reintentar") {
                            Task { await viewModel.getCharacters() }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(displayedCharacters, id: \.id) { character in
                                NavigationLink{
                                    SagasViewDetails(character: character, logoDB: $viewModel.logo)
                                } label: {
                                    BasicCharacterCardView(character: character, logo: viewModel.logo, favoriteCharacters: favoritesViewModel.favoriteCharactersIDs, deleteSuccessfull: $deleteCharacterFromFavorites)
                                        .environment(favoritesViewModel)
                                }
                            }
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("\(viewModel.sagas)")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 4)
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .toolbar {
                ToolbarItem {
                    SearchBarView(characterName: $characterName, isSearching: $isSearching, searchedCharacters: $searchedCharacters)
                        .onChange(of: characterName) { _, _ in
                            searchedCharacters = viewModel.searchCharacer(characterName: characterName)
                        }
                }
            }
        }
    }
}

#Preview {
    DragonBallView(referent: "all", logo: "DBLogo", sagas: "Personajes")
        .environment(FavoritesViewModel())
}
