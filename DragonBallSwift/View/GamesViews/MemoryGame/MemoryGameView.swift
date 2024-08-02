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
    @Binding var dismiss: Bool
    
    var body: some View {
        NavigationStack{
            // Diseño principal de la vista.
            ZStack{
                // Fondo de la vista.
                Color("BackgroundColor")
                    .ignoresSafeArea()
                // Scroll view para mostrar las cartas del juego y las cartas por emparejar.
                ScrollView{
                    // Utiliza GeometryReader para adaptarse al tamaño de la pantalla.
                    GeometryReader{geo in
                        VStack{
                            // Cuadrícula para mostrar las cartas del juego.
                            LazyVGrid(columns: memoryViewModel.forColumGrid, spacing: 15){
                                ForEach(memoryViewModel.createCardList().shuffled()){ card in
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
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar, content: {
                    Button(action: {
                        memoryViewModel.resetGameAll()
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
                
//                            ToolbarItem(placement: .automatic, content: {
//                                Image("logoDBGM").resizable()
//                                    .frame(width: 140, height: 40)
//                            })
            
                
                ToolbarItem(placement: .automatic, content: {
                    
                    Text("Puntuación: \(memoryViewModel.score)")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.accent)
                })
                
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss = false
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()
                            
                            Text("Volver atrás")
                                .font(.callout)
                        }
                    }

                }
            }
        }
    }
}

#Preview {
    return MemoryGameView(dismiss: .constant(false))
}
