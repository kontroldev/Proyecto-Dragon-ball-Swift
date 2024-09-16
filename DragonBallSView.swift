//
//  DragonBallSView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 6/9/24.
//

import SwiftUI

struct DragonBallSView: View {
    
     @State private var offsetY: CGFloat = -UIScreen.main.bounds.height
     @State private var isRotated = false
     @State private var kitRadius: CGFloat = 10.0
     @State private var kitColor: Color = .red
     
     var body: some View {
         ZStack{
             //(Color.backgroundColorEX).ignoresSafeArea()
             VStack{
                 Image("CCard")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 400)
                     .overlay{
                         Image("SuperLogo")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 300)
                             .shadow(color: .yellow,  radius: 20)
                             .offset(y: 70)
                         Image("iconConstruc").resizable()
                             .scaledToFit()
                             .frame(width: 90)
                             .offset(y: 150)
                             .shadow(color: kitColor, radius: kitRadius)
                             .rotation3DEffect(
                                 .degrees(isRotated ? 180 : 0),
                                                      
                                 axis: (x: 0.0, y: 1.0, z: 0.0)
                             )
                             .animation(.easeInOut(duration: 1.7).delay(1.7), value: isRotated)
                     }
                     .offset(y: offsetY)
                     .onAppear{
                         withAnimation(.easeOut(duration: 1.7)){
                             offsetY = -190
                         }
                         
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.7){
                             withAnimation(.easeInOut(duration: 1.7)){
                                 isRotated.toggle()
                             }
                             
                             withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)){
                                 kitRadius = 30.0
                                 kitColor = .green
                             }
                         }

                     }
             }
         }
  
     }
}

#Preview {
    DragonBallSView()
}
