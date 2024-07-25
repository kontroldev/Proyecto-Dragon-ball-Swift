//
//  ContentView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShow = false
    
    let menuItem = [
      ItemMenu(name: "Dragon Ball", imegenName: "logoDB", destination: AnyView(ViewDB())),
      ItemMenu(name: "Dragon Ball Z", imegenName: "logoDZ", destination: AnyView(ViewDZ())),
      ItemMenu(name: "Dragones", imegenName: "LogoDragones", destination: AnyView(ViewDragons()))
    ]
    
    var body: some View {
        VStack {
            TabView {
                Text("Wiki View")
                    .tabItem {
                        Label("Wiki", systemImage: "books.vertical.fill")
                    }
                
                Text("Juegos")
                    .tabItem {
                        Label("Juegos", systemImage: "gamecontroller.fill")
                    }
            }
        }
//        NavigationStack{
//            ZStack{
//                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .ignoresSafeArea()
//            
//                VStack{
//                    
//                    NavigationLink(destination: {
//                        MemoryGameView()
//                    }, label: {
//                        Image("logoDBGM").resizable()
//                            .frame(width: 360, height: 200)
//                    }).navigationSplitViewStyle(.automatic)
//                    GifImage("Gif1")
//                        .frame(width: 220, height: 150)
//                        .clipShape(Circle())
//                    Spacer()
//                    
//                    List(menuItem){item in
//                        NavigationLink(destination: item.destination){
//                            HStack{
//                                
//                                Text(item.name).font(.title3).bold()
//                                Spacer()
//                                Circle()
//                                    .foregroundStyle(Color.blue)
//                                    .frame(width: 50)
//                                    .overlay(content: {
//                                        Image(item.imegenName).resizable()
//                                            .frame(width: 60, height: 60)
//                                            .padding()
//                                    })
//                                
//                            }.padding()
//                        }
//                        .listRowBackground(Color.clear)
//                    }
//                    .listStyle(PlainListStyle())
//                }
//            
//            }
////            .toolbar{
////                NavigationLink("Ir AJuego", destination: {
////                    
////                    MemoryGameView()
////                    
////                })
////            }
//            
//        }
    }
}

#Preview {
    ContentView()
}
