//
//  GridView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct GridView: View {
    @Bindable var viewmodel: TetrisViewModel
    
    let boxSize: CGFloat = 20.0
    let spacing: CGFloat = 2.0
    
    var body: some View {
        VStack (spacing: spacing){
            ForEach(0..<viewmodel.height, id:\.self){ y in
                HStack(spacing: spacing){
                    ForEach(0..<viewmodel.width, id:\.self) { x in
                        
                        let squareGame = viewmodel.getSquareGame(x: x, y: y)
                        let color = squareGame?.color ??
                        Color.gray.opacity(0.2)
                        Rectangle()
                            .aspectRatio(1.0, contentMode: .fill)
                            .foregroundStyle(color)
                            .frame(width: boxSize, height: boxSize)
                            .padding(0)
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    @Previewable @State var viewmodels = TetrisViewModel()
    return GridView(viewmodel: viewmodels)
}
