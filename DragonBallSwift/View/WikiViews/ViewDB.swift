//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

struct ViewDB: View {
    @State private var viewModel: AllCharactersDBViewModel = AllCharactersDBViewModel()
    @State private var isLoadig = false
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            VStack {
//                Text("Personajes")
//                    .font(.title)
//                    .foregroundStyle(.accent)
//                    .fontWeight(.bold)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.AllCharacters, id: \.id) { item in
                            ZStack {
                                VStack {
                                    AsyncImage(url: URL(string: item.image)){ image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .offset(x: 60, y: 30)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                .scaleEffect(2)
                                
                                VStack {
                                    Text(item.name)
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
    ViewDB()
}
