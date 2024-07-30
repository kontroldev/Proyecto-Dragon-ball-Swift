//
//  HomeTreixView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct HomeTreixView: View {
    @State var viewModel = TetrisViewModel()
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    GridView(viewmodel: viewModel)
                        .offset(y: 20)
                }
                .padding(.top, 80)
                .padding(.horizontal, 20)
                Spacer()
                VStack{
                    Image("GokuTetrix")
                        .resizable()
                        .scaledToFit()
                        .offset(y: -15)
                    Scoreboard(viewmodel: viewModel)
                        .offset(x: -3, y : -15)
                        .shadow(color: .blue, radius: 17)
                }
            }
           Spacer()
            ControlsView(viewmodel: viewModel).padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .shadow(color: .blue, radius: 17)
        }
        .ignoresSafeArea(.all)
        .background(Color("BackgroundColor"))
        
    }
}

#Preview {
    HomeTreixView()
}
