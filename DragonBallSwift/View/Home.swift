//
//  Home.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 31/5/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack{
            
            Circle()
                .frame(width: 200, height: 200)
                .foregroundStyle(.blue)
                .overlay{
                    Image(systemName: "person.fill").font(.system(size: 220))
                }
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
            Text("hola")
            Image(systemName: "person")
            Button(action: {
                
            }, label: {
                Text("Button").padding(7)
            }).background(Color(red: 0.7, green: 0.70, blue: 0.5))
                .clipShape(.rect(cornerRadius: 9))
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    
    Home()
}


