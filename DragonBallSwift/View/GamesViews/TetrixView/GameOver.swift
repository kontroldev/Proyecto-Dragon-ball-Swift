//
//  GameOver.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 5/8/24.
//

import SwiftUI

struct GameOver: View {
    @Bindable var viewModel: TetrisViewModel
    
    @State private var shadowWindowRadius: CGFloat = 10.0

    var body: some View {
        VStack{
            Text("GAME OVER").font(.custom("SaiyanSans", size: 50))
                .foregroundStyle(.yellow).padding(5)
                .shadow(color: .red, radius: 10)
            VStack(alignment: .leading){
                Text("LEVEL - \(viewModel.level)").font(.title).bold().padding(5)
                Text("LINES - \(viewModel.lines)").font(.title).bold().padding(5)
                Text("SCORE - \(viewModel.score)").font(.title).bold().padding(5)
            }.foregroundStyle(.white)
                .onTapGesture {
                    viewModel.restartGame()
                }
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 2)
                .background(Color("CardColor").opacity(0.70))
                .clipShape(.rect(cornerRadius: 8))
            ).clipShape(.rect(cornerRadius: 8))
            .zIndex(1)
            .shadow(color: .blue, radius: shadowWindowRadius)
            .onAppear{
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)){
                    self.shadowWindowRadius = 30.0
                }
            }
    }
}

#Preview {
    @State var viewModel = TetrisViewModel()
    return GameOver(viewModel: viewModel)
}
