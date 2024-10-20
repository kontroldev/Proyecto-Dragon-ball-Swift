//
//  Scoreboard.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct Scoreboard: View {
    @Bindable var viewmodel: TetrisViewModel
    
    var titleTextSize:FontSize = .s24 // Tamaño del titulo que ire mostrando
    var infoTextSize: FontSize = .s20 // Tamaño de texto de la información
    var spacerHeight: CGFloat = 8 // crea un espacio entrew seccine
    var titlePaddingBottom: CGFloat = 8 // padding button que tiene el titulo
    var boxNextSize: CGFloat = 10.0
    let spacing: CGFloat = 2.0
    
    var scoreFormatted: String {
        String(format: "%06i", viewmodel.score)
    }
    
    var linesFormatted: String{
        String(format: "%04i", viewmodel.lines)
    }
    
    var levelFormatted: String {
        String(format: "%02i", viewmodel.level)
    }
    
    var nextShape: some View {
        VStack{
           Text("NEXT")
                .foregroundStyle(.white)
                .font(size: titleTextSize, type: .bold)
            VStack(spacing: spacing){
                ForEach(-1...2, id: \.self){ y in
                    HStack(spacing: spacing){
                        ForEach(3...6, id: \.self){x in
                            let color = colorNextShape(x: x, y: y) ??
                            Color.gray.opacity(0.2)
                            Rectangle()
                                .aspectRatio(1.0,contentMode: .fit)
                                .foregroundStyle(color)
                                .frame(width: boxNextSize, height: boxNextSize)
                                .padding(0)
                        }
                    }
                    
                }
            }.padding(.top, 4)
            
        }
        .padding(.bottom, 8)
    }
    
    private func colorNextShape(x: Int, y: Int) -> Color? {
        if let shape = viewmodel.nextActiveShape, let _ = shape.occuppiedPositions.first(where: {$0.y == y && $0.x == x}){
            return shape.color
        }
        return nil
    }
    
    var body: some View {
        VStack {
            nextShape
            
            Text("LEVEL") // titulo del nivel
                .font(size: titleTextSize, type: .bold)
                .foregroundStyle(.white)
                .padding(.bottom, titlePaddingBottom)
            Text(levelFormatted)
                .font(size: infoTextSize, type: .digital)
            
            Spacer()
                .frame(height: spacerHeight)
            
            Text("Lineas") // titulo de las lineas
                .font(size: titleTextSize, type: .bold)
                .padding(.bottom, titlePaddingBottom)
            Text(linesFormatted)
                .font(size: infoTextSize, type: .digital)
            
            Spacer()
                .frame(height: spacerHeight)
            
            Text("SCORE") // titulo de la puntación
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
                .stroke(Color.white, lineWidth: 2)
                .background(Color.black.opacity(0.70))
                .clipShape(.rect(cornerRadius: 8))
            ).clipShape(.rect(cornerRadius: 8))
        .foregroundStyle(.white)
    }
}

#Preview {
    @Previewable @State var preViewModel = TetrisViewModel()
   return Scoreboard(viewmodel: preViewModel)
}

