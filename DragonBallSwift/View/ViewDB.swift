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
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.white, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                List{
                    ForEach(viewModel.AllCharacters, id: \.id){item in
                        VStack(alignment: .leading){
                            HStack{
                                AsyncImage(url: URL(string: item.image)){ image in
                                    image.resizable()
                                }placeholder: {
                                    ProgressView()
                                }.frame(width: 100, height: 100)
                                Text(item.name).font(.title2).bold()
                                
                                
                            }
                            Text(item.planet)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                
                .navigationTitle("Dragon Ball")
            }
        }
    }
}

#Preview {
    ViewDB()
}
