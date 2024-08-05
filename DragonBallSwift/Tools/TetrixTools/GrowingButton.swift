//
//  StyleButtStar.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 5/8/24.
//

import SwiftUI

struct StyleButtStar: View {
    var body: some View {
        Button("Star Game") {
            print("Button pressed!")
        }
        .bold()
        .buttonStyle(GrowingButton(color: .blue))
        .shadow(color: .blue, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct GrowingButton: ButtonStyle {
    var color: Color?
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
#Preview {
    StyleButtStar()
}
