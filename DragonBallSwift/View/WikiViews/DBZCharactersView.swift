//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import SwiftUI

struct DBZCharactersView: View {
    @State private var viewModel: AllCharactersDZViewModel = AllCharactersDZViewModel()
    @State private var favoriteViewModel = FavoritesViewModel()
    @State private var isLoadig = false
    
    @State private var deleteCharacterFromFavorites = false
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllCharacters, id: \.id) { character in
                            NavigationLink{ // ⬅️ Jacob, ya estan todas las tarjetas de personajes!!! 🤘
                                ViewDetails(Caracter: character, LogoDB: $viewModel.logo)
                            } label: {
                                BasicCharacterCardView(character: character, logo: viewModel.logo, favoriteCharacters: $favoriteViewModel.favoriteCharacters, deleteSuccessfull: $deleteCharacterFromFavorites)
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
                        Button {
                            //TODO: Implementar funcionalidad de buscar personaje
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
            .task {
                await favoriteViewModel.getFavoriteCharacters()
            }
        }
    }
}

#Preview {
    DBZCharactersView()
}
