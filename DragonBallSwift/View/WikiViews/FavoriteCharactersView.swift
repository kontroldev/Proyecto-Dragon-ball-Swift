//
//  FavoriteCharactersView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 04-08-24.
//

import SwiftUI

struct FavoriteCharactersView: View {

    @Environment(FavoritesViewModel.self) var favoriteViewModel
    @Environment(\.dismiss) var dismiss
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
                await favoriteViewModel.getFavoriteCharactersIDs()
                await favoriteViewModel.getFavoriteCharactersModels()
                favoriteViewModel.isLoading = false
              
            }
            .toolbar{
                Button(role: .cancel, action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                })
            }
        }
    }
}

#Preview {
    FavoriteCharactersView()
}
