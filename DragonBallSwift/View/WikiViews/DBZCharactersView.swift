//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import SwiftUI

struct DBZCharactersView: View {
    @State private var viewModel: AllCharactersDZViewModel = AllCharactersDZViewModel()
    @State private var isLoadig = false
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllCharacters, id: \.id) { character in
                            NavigationLink{ // ⬅️ Jacob, ya estan todas las tarjetas de personajes!!! 🤘
                                ViewDetails(Caracter: character)
                            } label: {
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
}

#Preview {
    DBZCharactersView()
}
