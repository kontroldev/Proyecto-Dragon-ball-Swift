//
//  ContentView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShow = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            
                VStack{
                    
                    NavigationLink(destination: {
                        MemoryGameViewBuilder().build()
                    }, label: {
                        Image("logoDBGM").resizable()
                            .frame(width: 360, height: 200)
                    }).navigationSplitViewStyle(.automatic)
                    GifImage("Gif1")
                        .frame(width: 220, height: 150)
                        .clipShape(Circle())
                    Spacer()
                }
            
            }
//            .toolbar{
//                NavigationLink("Ir AJuego", destination: {
//                    
//                    MemoryGameView()
//                    
//                })
//            }
            
        }
    }
}

#Preview {
    ContentView()
}
