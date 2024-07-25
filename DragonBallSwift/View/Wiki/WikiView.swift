//
//  WikiView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 24-07-24.
//

import SwiftUI

struct WikiView: View {
    
    let menuItem = [
        ItemMenu(name: "Dragon Ball", imegenName: "logoDB", destination: AnyView(ViewDB())),
        ItemMenu(name: "Dragon Ball Z", imegenName: "logoDZ", destination: AnyView(ViewDZ())),
        ItemMenu(name: "Dragones", imegenName: "LogoDragones", destination: AnyView(ViewDragons()))
    ]
    
    var body: some View {
        VStack {
            Text("Personajes")
                .font(.title)
                .foregroundStyle(.accent)
                .fontWeight(.bold)
            
            ScrollView {
                ForEach(menuItem) { item in
                    HStack{
                        Text(item.name).font(.title3).bold()
                            .foregroundStyle(.accent)
                        
                        Spacer()
                        
                        Circle()
                            .frame(width: 50)
                            .overlay(content: {
                                Image(item.imegenName)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding()
                            })
                        
                    }
                    .padding()
                    .background(Color("CardColor"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
        }
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    WikiView()
}
