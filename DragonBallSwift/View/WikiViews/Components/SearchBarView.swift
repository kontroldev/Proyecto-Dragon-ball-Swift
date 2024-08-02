//
//  SearchBarView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 01-08-24.
//

import SwiftUI

struct SearchBarView: View {
    
    @FocusState private var searchBarFocus: Bool
    @Binding var characterName: String
    @Binding var isSearching: Bool
    @Binding var searchedCharacters: [CharactersModel]
    
    var body: some View {
        if !isSearching {
            Button {
                withAnimation(.bouncy(duration: 0.3, extraBounce: 0)) {
                    isSearching = true
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.footnote)
            }
        } else {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.footnote)
                    .foregroundStyle(Color.gray.opacity(0.7))
                
                TextField("Busca un personaje", text: $characterName)
                    .font(.footnote)
                    .focused($searchBarFocus)
                
                Button {
                    withAnimation {
                        isSearching = false
                        searchedCharacters = []
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.footnote)
                }
            }
            .padding(4)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
            .frame(height: 12)
            .onAppear {
                searchBarFocus = true
            }
        }
    }
}

#Preview {
    SearchBarView(characterName: .constant("Goku"), isSearching: .constant(false), searchedCharacters: .constant([CharactersModel(id: "666808ce2a01878ca18a9f6d", name: "Goku", genre:"", race: "", image: "", planet: "", description: "", biography: "")]))
}
