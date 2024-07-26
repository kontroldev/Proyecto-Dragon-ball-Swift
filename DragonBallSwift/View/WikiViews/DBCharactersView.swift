//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct DBCharactersView: View {
    @State private var viewModel: AllCharactersDBViewModel = AllCharactersDBViewModel()
    @State private var isLoadig = false
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllCharacters, id: \.id) { character in
                            BasicCharacterCardView(character: character)
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
    }
}

#Preview {
    DBCharactersView()
}
