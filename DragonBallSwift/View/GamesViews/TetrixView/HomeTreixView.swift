//
//  HomeTreixView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import SwiftUI

struct HomeTreixView: View {
    @State var viewModel = TetrisViewModel()
    
    @Binding var dismiss: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack {
                        GridView(viewmodel: viewModel)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    ZStack{
                        Scoreboard(viewmodel: viewModel)
                            .shadow(color: .blue, radius: 17)
                            .offset(y: 30)
                        
                        Image("GokuTetrix")
                            .resizable()
                            .scaledToFit()
                            .offset(y: -210)
                        
                        Button("Star Game") {
                            viewModel.restartGame()
                        }.disabled(viewModel.gameIsOver || viewModel.gameIsStopped ?  false : true)
                        .bold()
                        .buttonStyle(GrowingButton(color: viewModel.gameIsOver || viewModel.gameIsStopped ? .red : .red.opacity(0.5)))
                        .shadow(color: .blue, radius: 10)
                        .offset(y: 250)
                    }
                }

                ControlsView(viewmodel: viewModel)
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .shadow(color: .blue, radius: 8)
            }
            .frame(maxHeight: .infinity)
            .background(Color.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss = false
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()
                            
                            Text("Volver")
                                .font(.callout)
                        }
                    }

                }
            }
            .overlay{
                if viewModel.gameIsOver{
                    GameOver(viewModel: viewModel)
                }
            }
        }
        
    }
}

#Preview {
    return HomeTreixView(dismiss: .constant(false))
}
