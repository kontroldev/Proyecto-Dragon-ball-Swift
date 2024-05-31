//
//  ContentView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Image("logoDBGM").resizable()
                    .frame(width: 360, height: 200)
                
            }
            .padding()
            .toolbar{
                NavigationLink("Ir AJuego", destination: {
                    
                    MemoryGameView()
                    
                })
            }
            
        }
    }
}

#Preview {
    ContentView()
}
