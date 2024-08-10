//
//  GameOverMGView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 10/8/24.
//

import SwiftUI

struct GameOverMGView: View {
    @Bindable var memoryViewModel: MemoryGameViewModel
    
    @State private var buttonRadius: CGFloat = 20.0
    @State private var isGameOver: Bool = false
    
    var body: some View {
        VStack{
            Text("GAME OVER").font(.custom("SaiyanSans", size: 50))
                .foregroundStyle(.yellow).padding(5)
                .shadow(color: .red, radius: 10)
            Button("Star Game"){
                memoryViewModel.resetGameAll(cardList: memoryViewModel.cardList)
            }.padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8).foregroundStyle(.red)
                ).clipShape(.rect(cornerRadius: 8))
                .shadow(color: .orange, radius: buttonRadius, x: 0, y: 0)
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
                    .background(Color("CardColor").opacity(0.70))
                    .clipShape(.rect(cornerRadius: 8))
                ).clipShape(.rect(cornerRadius: 8))
                .zIndex(1)
                .shadow(color: .blue, radius: 10)
                .onAppear{
                    withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)){
                        self.buttonRadius = 50.0
                    }
                }
    }
}

#Preview {
    @State var memoryViewModel = MemoryGameViewModel()
    return GameOverMGView(memoryViewModel: memoryViewModel)
}
