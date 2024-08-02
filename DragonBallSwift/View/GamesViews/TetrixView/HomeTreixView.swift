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
    //                        .offset(x: -3, y : -15)
                            .shadow(color: .blue, radius: 17)
                        
                        Image("GokuTetrix")
                            .resizable()
                            .scaledToFit()
                            .offset(y: -160)
                    }
                }

                ControlsView(viewmodel: viewModel)
                    .padding(.top, 30)
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
        }
    }
}

#Preview {
    return HomeTreixView(dismiss: .constant(false))
}
