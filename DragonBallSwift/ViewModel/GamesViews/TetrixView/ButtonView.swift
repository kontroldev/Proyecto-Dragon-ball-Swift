//
//  ButtonView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct ButtonView: View {
    var iconSystemName:  String
    var action: () -> Void
    
    var iconSize: CGFloat {
        return 70.0
    }
    
    var StyleRadius: CGFloat = 35
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
           Image(systemName: iconSystemName)
                .foregroundStyle(Color.white)
                .frame(width: iconSize, height: iconSize)
                .overlay(
                    RoundedRectangle(cornerRadius: StyleRadius)
                        .stroke(Color.white, lineWidth: 6)
                )
        })
        .frame(width: iconSize, height: iconSize , alignment: Alignment.center)
        .background(Color.black)
        .clipShape(Circle())
        .buttonStyle(IconButtonRoundDefault())
    }
}

struct IconButtonRoundDefault: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeInOut(duration: 0.6), value: configuration.isPressed)
    }
}



#Preview {
    ButtonView(iconSystemName: IconButtons.icons.rotateRight){}
}
