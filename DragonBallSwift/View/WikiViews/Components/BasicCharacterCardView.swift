//
//  BasicCharacterCardView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import Kingfisher
import SwiftUI

struct BasicCharacterCardView: View {
    @Environment(FavoritesViewModel.self) private var favorites
    let character: CharactersModel
    let logo: String
    @State private var isLoading = true
    @State private var imageFailed = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                KFImage(URL(string: character.image))
                    .onSuccess { _ in
                        isLoading = false
                        imageFailed = false
                    }
                    .onFailure { _ in
                        isLoading = false
                        imageFailed = true
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                if isLoading { ProgressView() }
                if imageFailed { Image(systemName: "photo").font(.largeTitle) }
            }
            .accessibilityHidden(true)
            Text(character.name)
                .font(.headline)
                .foregroundStyle(Color.textColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(LinearGradient(colors: [.cardColor, .cardColorEX], startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task(id: character.image) {
            if URL(string: character.image)?.scheme == nil {
                isLoading = false
                imageFailed = true
            }
        }
        .accessibilityElement(children: .combine)
        .contextMenu {
            Button {
                Task {
                    if favorites.isFavorite(characterID: character.id) {
                        _ = await favorites.removeFromFavorites(characterID: character.id)
                    } else {
                        await favorites.addToFavorites(characterID: character.id)
                    }
                }
            } label: {
                Label(
                    favorites.isFavorite(characterID: character.id)
                        ? "Quitar de favoritos" : "Agregar a favoritos",
                    systemImage: favorites.isFavorite(characterID: character.id) ? "heart.fill" : "heart")
            }
        }
    }
}

#Preview {
    BasicCharacterCardView(character: Mocks().character, logo: "DBLogo")
        .environment(FavoritesViewModel())
}
