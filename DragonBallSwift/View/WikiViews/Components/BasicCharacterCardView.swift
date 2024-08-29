//
//  BasicCharacterCardView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import SwiftUI
import Kingfisher

struct BasicCharacterCardView: View {
    
    @State private var favoriteCharactersViewModel: FavoritesViewModel = FavoritesViewModel()
    @State var character: CharactersModel
    @State var logo: String
    @State var isFavorite: Bool = false
    @State var isLoading: Bool = true
    
    @Binding var favoriteCharacters: [FavoriteCharacter]
    @Binding var deleteSuccessfull: Bool
    
    var body: some View {
        ZStack {
            LazyVStack(alignment: .trailing) {
                KFImage(URL(string: character.image))
                    .onSuccess { _ in
                        isLoading = false
                    }
                    .resizable()
                    .scaledToFit()
                    .offset(x: 10, y: 30)
                    .frame(width: 120, height: 120)
                    .scaleEffect(1.5)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack {
                Text(character.name)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.accent)
                    .padding(8)
                    .padding(.top, 10)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 120, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .contextMenu {
            NavigationLink {
                ViewDetails(Caracter: character, LogoDB: $logo)
            } label: {
                HStack {
                    Text("Ver más información")
                    
                    Image(systemName: "info.circle")
                }
            }
            
            Button {
                Task {
//                    //Si el personaje ya está en favoritos y se presiona el botón, se elimina el personaje de favoritos, sino se agrega a favoritos
//                    if isFavorite {
//                        // Si el personaje está en favoritos, intenta eliminarlo
//                      deleteSuccessfull = await favoriteCharactersViewModel.removeFromFavorites(characterID:  character.id)
//                        
//                        // Si la eliminación fue exitosa, actualiza el estado a false
//                        if deleteSuccessfull {
//                            isFavorite = false
//                        }
//                    } else {
//                        // Si el personaje no está en favoritos, intenta agregarlo
//                        await favoriteCharactersViewModel.addToFavorites(characterID: character.id)
//                        
//                        // Actualiza el estado isFavorite después de intentar agregar
//                        isFavorite = await favoriteCharactersViewModel.checkIsFavorite(characterID: character.id)
//                    }
                }
            } label: {
                HStack {
                    Text(isFavorite ? "Quitar de favoritos" : "Agregar a favoritos")
                    
                    Image(systemName: !isFavorite ? "heart" : "heart.fill")
                        .foregroundStyle(!isFavorite ? .accent : .red)
                }
            }
        }
        .frame(height: 120)
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(content: {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
        })

        .padding(.horizontal, 4)
        .task {
            isFavorite = favoriteCharacters.contains(where: {Int( $0.characterID) == character.id })
        }
    }
}

#Preview {
    @State var mock = Mocks()
    
    return BasicCharacterCardView(character: mock.character, logo: "DBLogo", favoriteCharacters: .constant([FavoriteCharacter(characterID: "16")]), deleteSuccessfull: .constant(false))
}
