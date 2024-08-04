//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import SwiftUI

struct DBZCharactersView: View {
    //Estados para obtener los personajes de la API
    @State private var viewModel: AllCharactersDZViewModel = AllCharactersDZViewModel()
    @State private var isLoadig = false
    
    //Estados para manejar los personajes favoritos
    @State private var favoriteViewModel = FavoritesViewModel()
    @State private var deleteCharacterFromFavorites = false
    
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
                            NavigationLink{ // ⬅️ Jacob, ya estan todas las tarjetas de personajes!!! 🤘
                                ViewDetails(Caracter: character, LogoDB: $viewModel.logo)
                            } label: {
                                BasicCharacterCardView(character: character, logo: viewModel.logo, favoriteCharacters: $favoriteViewModel.favoriteCharactersIDs, deleteSuccessfull: $deleteCharacterFromFavorites)
                            }
                        }
                    }
                }
                .overlay {
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                        }
                    }
                }
            }
            .navigationTitle("Dragon Ball Z")
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
                await favoriteViewModel.getFavoriteCharactersIDs()
            }
        }
    }
}

#Preview {
    DBZCharactersView()
}
