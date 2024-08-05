//
//  WikiView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 24-07-24.
//

import SwiftUI

struct WikiView: View {
    
    let menuItem = [
        ItemMenu(name: "Dragon Ball", imegenName: "DBLogo", destination: AnyView(DBCharactersView())),
        ItemMenu(name: "Dragon Ball Z", imegenName: "ZLogo", destination: AnyView(DBZCharactersView())),
        ItemMenu(name: "Dragones", imegenName: "LogoDragones", destination: AnyView(DragonsView()))
    ]
    
    @State private var showFavorites: Bool = false
    
    var body: some View {
        
        //Todo envuelto en un NavigationStack, para poder navegar a la vista seleccionada a través de un Navigation Link
        NavigationStack {
            VStack {
//                Text("Personajes")
//                    .font(.title)
//                    .foregroundStyle(.accent)
//                    .fontWeight(.bold)
                
                ScrollView {
                    ForEach(menuItem) { item in
                        NavigationLink(destination: item.destination) {
                            HStack {
                                Text(item.name).font(.title3).bold()
                                    .foregroundStyle(.accent)
                                
                                Spacer()
                                
                                Image(item.imegenName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Personajes")
            .background(Color("BackgroundColor"))
            .toolbar {
                ToolbarItem {
                    Button {
                        showFavorites = true
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "heart.fill")
//                                .font(.footnote)
                            
//                            Text("Favoritos")
//                                .font(.caption2)
                        }
                    }
                }
            }
            .sheet(isPresented: $showFavorites) {
                FavoriteCharactersView()
            }
        }
    }
}

#Preview {
    WikiView()
}
