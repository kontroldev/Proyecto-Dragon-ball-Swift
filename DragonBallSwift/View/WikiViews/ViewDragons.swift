//
//  ViewDragons.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 17/7/24.
//

import SwiftUI

struct ViewDragons: View {
    
    @State private var viewModel: AllDragonsViewModel = AllDragonsViewModel()
    @State private var isLoadig = false
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllDragos, id: \.id) { character in
                            ZStack {
                                VStack {
                                    AsyncImage(url: URL(string: character.image)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .offset(x: 70, y: 20)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                .scaleEffect(1.5)
                                
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
                            .frame(height: 120)
                            .background(Color("CardColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 4)
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
    ViewDragons()
}
