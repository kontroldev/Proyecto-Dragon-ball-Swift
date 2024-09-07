//
//  MemoryGameView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

/// Vista principal del juego de memoria.
struct MemoryGameView: View {
    /// ViewModel para manejar la lógica del juego de memoria.
    @State var memoryViewModel =  MemoryGameViewModel()
   
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            // Diseño principal de la vista.
            ZStack{
                // Fondo de la vista.
                RadialGradient(colors: [ Color("BackgroundColor"), Color.backgroundColorEX], center: .center, startRadius: 30, endRadius: 380)
                    .ignoresSafeArea()
                // Scroll view para mostrar las cartas del juego y las cartas por emparejar.
                ScrollView{
                    // Utiliza GeometryReader para adaptarse al tamaño de la pantalla.
                    GeometryReader{geo in
                        VStack{
                            // Cuadrícula para mostrar las cartas del juego.
                            LazyVGrid(columns: memoryViewModel.forColumGrid, spacing: 15){
                                ForEach(memoryViewModel.cardList){ card in
                                    CardMemoryView(cardMemory: card ,
                                                   memoryViewModel: memoryViewModel,
                                                   width: Int(geo.size.width/4 - 10))
                                }
                            }
                            
                            // Sección para mostrar las cartas por emparejar.
                            VStack{
                                // Título de la sección.
                                Text("Match these cards to win:").font(.system(size: 12).bold())
                                
                                // Cuadrícula para mostrar las cartas por emparejar.
                                LazyVGrid(columns: memoryViewModel.sixColumGrid, spacing: 5){
                                    
                                    ForEach(memoryViewModel.cardValues, id: \.self){ cardValue in
                                        
                                        if !memoryViewModel.matchedCards.contains(where: {$0.text == cardValue}){
                                            Image(cardValue).resizable()
                                                .frame(width: 30 , height: 30)
                                                .shadow(color: .blue,  radius: 3)
                                                
                                            
                                        }
                                    }
                                    
                                }
                            }
                            .modifier(MemoryBacgroundSingle())

                            
                        }
                    }.padding(9)
                }
                if memoryViewModel.gameOver(memoryViewModel.attempts){
                    GameOverMGView(memoryViewModel: memoryViewModel)
                }

            }


            .onAppear{
                memoryViewModel.cardList = memoryViewModel.createCardList()
                memoryViewModel.resetGameAll(cardList: memoryViewModel.cardList)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar, content: {
                    Button(action: {
                        memoryViewModel.resetGameAll(cardList: memoryViewModel.cardList)
                    }, label: {
                        VStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                 .foregroundStyle(.red)
                                 .font(.title)
                                 .fontWeight(.black)
                            
                            Text("Reiniciar")
                                .font(.footnote)
                                .fontWeight(.bold)
                        }
                    })
                    .padding(.top, 12)
                        
                })
                
                ToolbarItem(placement: .automatic, content: {
                    
                    Text("Puntuación: \(memoryViewModel.score)")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.accent)
                })
                
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()
                            
                            Text("Volver")
                                .font(.callout)
                        }
                    }

                }
            }
            
        }
    }
}

#Preview {
    return MemoryGameView()
}
