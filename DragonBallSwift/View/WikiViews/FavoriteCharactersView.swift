//
//  FavoriteCharactersView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 04-08-24.
//

import SwiftUI

struct FavoriteCharactersView: View {
    
    @State private var dbCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragonball",
                                                                                        logo: "DBLogo",
                                                                                        sagas: "Dragon Ball")
    
    @State private var dbzCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragonballz",
                                                                                         logo: "ZLogo",
                                                                                         sagas: "Dragon Ball Z")
    
    @State private var dbgtCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragonballgt",
                                                                                          logo: "GTLogo",
                                                                                          sagas: "Dragon Ball GT")
    
    @State private var dbdCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragons",
                                                                                         logo: "LogoDragones",
                                                                                         sagas: "Dragones")
    
    @Environment(FavoritesViewModel.self) var favoriteViewModel
    @State private var deleteCharacterFromFavorites = false
    @State private var logo: String = ""
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favoriteViewModel.favoriteCharacters, id: \.id) { character in
                            NavigationLink{
                                SagasViewDetails(character: character, logoDB: $logo)
                            } label: {
                                BasicCharacterCardView(character: character, logo: logo, favoriteCharacters: favoriteViewModel.favoriteCharactersIDs, deleteSuccessfull: $deleteCharacterFromFavorites)
                            }
                        }
                    }
                }
                .overlay {
                    ZStack {
                        if favoriteViewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .navigationTitle("Personajes Favoritos")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                favoriteViewModel.isLoading = true
                await dbzCharactersViewModel.getCharacters()
                await dbgtCharactersViewModel.getCharacters()
                await favoriteViewModel.getFavoriteCharactersIDs()
                
                favoriteViewModel.getFavoriteCharactersModels(favoriteCharactersFromDB: dbCharactersViewModel.characterModel, favoriteCharactersFromDBZ: dbzCharactersViewModel.characterModel, favoriteCharactersFromDBGT: dbgtCharactersViewModel.characterModel)

                favoriteViewModel.isLoading = false
            }
        }
    }
}

#Preview {
    FavoriteCharactersView()
}
