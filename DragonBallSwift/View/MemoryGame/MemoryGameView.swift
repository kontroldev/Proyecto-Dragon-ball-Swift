//
//  MemoryGameView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 30/5/24.
//

import SwiftUI

struct MemoryGameView: View {
    private var forColumGrid = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    private var sixColumGrid = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    
    @State var cards = createCadList().shuffled()
    @State var matchedCards = [CardMemoryModel]()
    @State var userChoices = [CardMemoryModel]()
    
    var body: some View {
        
        ZStack{
            Color(red: 0.0, green: 0.3, blue: 0.5)
                .ignoresSafeArea()
            ScrollView{
                GeometryReader{geo in
                    VStack{
                        Image("logoDBGM").resizable()
                            .frame(width: 290, height: 70)
                            .padding(.top, -10)
                        LazyVGrid(columns: forColumGrid, spacing: 15){
                            ForEach(cards){card in
                                CardMemoryView(cardMemory: card,
                                               matchedCards: $matchedCards,
                                               userChoises: $userChoices,
                                               width: Int(geo.size.width/4 - 10))
                            }
                        }
                        
                        VStack{
                            Text("Match these cards to win:").bold()
                            LazyVGrid(columns: sixColumGrid, spacing: 5){
                                ForEach(cardValue, id: \.self){ cardValue in
                                    
                                    if !matchedCards.contains(where: {$0.text == cardValue}){
                                        // Text(cardValue).font(.system(size: 30))
                                        Image(cardValue).resizable()
                                            .frame(width: 35 , height: 35)
                                            .padding(2)
                                        
                                    }
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                        .padding(.horizontal, 20)
                        .padding(.top, 6)
                        
                    }
                }.padding(9)
            }
        }
    }
}

#Preview {
    MemoryGameView()
}
