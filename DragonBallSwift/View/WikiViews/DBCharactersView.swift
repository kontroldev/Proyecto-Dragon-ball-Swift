//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct DBCharactersView: View {
    //Estados para obtener los personajes de la API
    @State private var viewModel: AllCharactersDBViewModel = AllCharactersDBViewModel()
    @State private var isLoading = false
    
    //Estados para manejar los personajes favoritos
    @State private var favoritesViewModel: FavoritesViewModel = FavoritesViewModel()
    @State private var deleteCharacterFromFavorites: Bool = false
    
    //Estados para búsqueda de personajes
    @State private var isSearching: Bool = false
    @FocusState private var searchBarFocus: Bool
    @State private var searchedCharacters: [CharactersModel] = []
    @State private var characterName: String = ""
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(searchedCharacters.isEmpty ? viewModel.allCharacters : searchedCharacters, id: \.id) { character in
                            NavigationLink{
                                ViewDetails(Caracter: character, LogoDB: $viewModel.logo)
                            } label: {
                                BasicCharacterCardView(character: character, logo: viewModel.logo, favoriteCharacters: $favoritesViewModel.favoriteCharactersIDs, deleteSuccessfull: $deleteCharacterFromFavorites)
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
            }
            .navigationTitle("Dragon Ball")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 4)
            .background(Color("BackgroundColor"))
            .toolbar {
                ToolbarItem {
                    SearchBarView(characterName: $characterName, isSearching: $isSearching, searchedCharacters: $searchedCharacters)
                        .onChange(of: characterName) { _, _ in
                            searchedCharacters = viewModel.searchCharacer(characterName: characterName)
                        }
                }
            }
            .task {
                await favoritesViewModel.getFavoriteCharactersIDs()
            }
        }
    }
}

#Preview {
    DBCharactersView()
}
