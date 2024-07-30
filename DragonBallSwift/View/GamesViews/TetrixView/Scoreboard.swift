//
//  Scoreboard.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct Scoreboard: View {
    @Bindable var viewmodel: TetrisViewModel
    
    var titleTextSize:FontSize = .s24
    var infoTextSize: FontSize = .s20
    var spacerHeight: CGFloat = 8
    var titlePaddingBottom: CGFloat = 8
    
    var scoreFormatted: String {
        String(format: "%06i", viewmodel.scorte)
    }
    
    var linesFormatted: String{
        String(format: "%04i", viewmodel.lines)
    }
    
    var levelFormatted: String {
        String(format: "%02i", viewmodel.level)
    }
    
    var body: some View {
        VStack {
            Text("LEVEL")
                .font(size: titleTextSize, type: .bold)
                .foregroundStyle(.white)
                .padding(.bottom, titlePaddingBottom)
            Text(levelFormatted)
                .font(size: infoTextSize, type: .digital)
            
            Spacer()
                .frame(height: spacerHeight)
            
            Text("Lineas")
                .font(size: titleTextSize, type: .bold)
                .padding(.bottom, titlePaddingBottom)
            Text(linesFormatted)
                .font(size: infoTextSize, type: .digital)
            
            Spacer()
                .frame(height: spacerHeight)
            
            Text("SCORE")
                .font(size: titleTextSize, type: .bold)
                .padding(.bottom, titlePaddingBottom)
            Text(scoreFormatted)
                .font(size: infoTextSize, type: .digital)
            
        }
        .padding(.horizontal,20)
        .padding(.vertical, 10)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("CardColor"), lineWidth: 2)
                .background(Color.black.opacity(0.70))
                .clipShape(.rect(cornerRadius: 8))
            ).clipShape(.rect(cornerRadius: 8))
        .foregroundStyle(.white)
    }
}

#Preview {
    @State var preViewModel = TetrisViewModel()
   return Scoreboard(viewmodel: preViewModel)
}
