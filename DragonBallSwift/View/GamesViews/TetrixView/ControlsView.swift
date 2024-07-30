//
//  ControlsView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct ControlsView: View {
    @Bindable var viewmodel: TetrisViewModel
    
    var body: some View {
        HStack(spacing: -10){
            ButtonView(iconSystemName: IconButtons.icons.arrowBack){
                viewmodel.moveLeft()
            }
            ButtonView(iconSystemName: IconButtons.icons.arrowshapeDown, action: {
                viewmodel.moveDown()
            }).offset(y: 60)
            
            ButtonView(iconSystemName: IconButtons.icons.arrowForward){
                viewmodel.moveRight()
            }
            
            Spacer()
            
            ButtonView(iconSystemName: IconButtons.icons.rotateLeft){
                viewmodel.rotateShape()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

#Preview {
    @State var preViewModel = TetrisViewModel()
   return ControlsView(viewmodel: preViewModel)
}

