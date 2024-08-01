//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct DBCharactersView: View {
    @State private var viewModel: AllCharactersDBViewModel = AllCharactersDBViewModel()
    @State private var favoritesViewModel: FavoritesViewModel = FavoritesViewModel()
    @State private var isLoadig = false
    
    @State private var deleteCharacterFromFavorites: Bool = false
    @State private var isSearching: Bool = false
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
                                BasicCharacterCardView(character: character, logo: viewModel.logo, favoriteCharacters: $favoritesViewModel.favoriteCharacters, deleteSuccessfull: $deleteCharacterFromFavorites)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Personajes")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 4)
            .background(Color("BackgroundColor"))
            .toolbar {
                ToolbarItem {
                    if !isSearching {
                        Button {
                            withAnimation {
                                isSearching = true
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "magnifyingglass")
                                .font(.headline)
                            
                            TextField("Busca un personaje", text: $characterName)
                                .onChange(of: characterName) { _, _ in
                                    searchedCharacters = viewModel.searchCharacer(characterName: characterName)
                                }
                            
                            Button {
                                withAnimation {
                                    isSearching = false
                                    searchedCharacters = []
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                        }
                        .padding(.horizontal, 4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        .frame(height: 12)
                    }
                }
            }
            .task {
                await favoritesViewModel.getFavoriteCharacters()
            }
        }
    }
}

#Preview {
    DBCharactersView()
}
