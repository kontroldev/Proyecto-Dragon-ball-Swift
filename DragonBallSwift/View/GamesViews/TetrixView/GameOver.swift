//
//  GameOver.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 5/8/24.
//

import SwiftUI

struct GameOver: View {
    @Bindable var viewModel: TetrisViewModel

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
            .shadow(color: .blue, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @State var viewModel = TetrisViewModel()
    return GameOver(viewModel: viewModel)
}
