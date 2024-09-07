//
//  FavoriteCharactersView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 04-08-24.
//

import SwiftUI

struct FavoriteCharactersView: View {
    
    @State private var dbCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragonball", logo: "DBLogo")
    @State private var dbzCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragonballz", logo: "ZLogo")
    @State private var dbdCharactersViewModel: CharactersViewModel = CharactersViewModel(referent: "dragons", logo: "dragons")
    @State private var favoriteViewModel = FavoritesViewModel()
    
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
                                BasicCharacterCardView(character: character, logo: "", favoriteCharacters: $favoriteViewModel.favoriteCharactersIDs, deleteSuccessfull: $deleteCharacterFromFavorites)
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
//                favoriteViewModel.isLoading = true
//                await dbzCharactersViewModel.getAllCharacters()
//                await favoriteViewModel.getFavoriteCharactersIDs()
//                
//                favoriteViewModel.getFavoriteCharactersModels(favoriteCharactersFromDB: dbCharactersViewModel.characterModel, favoriteCharactersFromDBZ: dbzCharactersViewModel.characterModel)
//
//                favoriteViewModel.isLoading = false
            }
        }
    }
}

#Preview {
    FavoriteCharactersView()
}
