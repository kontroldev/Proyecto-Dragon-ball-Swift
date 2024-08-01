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
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllCharacters, id: \.id) { character in
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
                    Button {
                        //TODO: Implementar funcionalidad de buscar personaje
                    } label: {
                        Image(systemName: "magnifyingglass")
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
