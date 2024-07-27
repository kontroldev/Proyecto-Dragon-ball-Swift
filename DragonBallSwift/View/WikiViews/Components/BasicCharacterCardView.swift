//
//  BasicCharacterCardView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 25-07-24.
//

import SwiftUI

struct BasicCharacterCardView: View {
    
    @State var character: CharactersModel
    
    var body: some View {
        ZStack {
            VStack {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .offset(x: 60, y: 30)
                } placeholder: {
                    HStack{
                        GifImage("tumblr_5d02caa6c1505584156a309d7c38a5d5_ef84c56e_250")
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .offset(x: 100, y: -36)
                        Text("Please wait ...")
                            .foregroundStyle(.white).offset(x: 95, y: -30)
                        ProgressView()
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .scaleEffect(2)
            
            VStack {
                Text(character.name)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.accent)
                    .padding(8)
                    .padding(.top, 10)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 120, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(height: 120)
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 4)
    }
}

#Preview {
    @State var character = CharactersModel(id: "666808ce2a01878ca18a9f6d", name: "Son Goku", genre: "Masculino", race: "Saiyajin", image: "https://apidragonball.vercel.app/static/images/GokuPeque.png", planet: "Vegeta, (criado en la tierra)", description: "Son Goku (孫そん悟ご空くう Son Gokū¿?) es el protagonista principal del manga y anime de Dragon Ball creado por Akira Toriyama. Su nombre real y de nacimiento es Kakarotto (カカロット¿?) y es uno de los pocos saiyanos que lograron sobrevivir a la destrucción total del Planeta Vegeta del Universo 7. Es el segundo hijo de Bardock y Gine, hermano menor de Raditz, nieto adoptivo de Son Gohan, esposo de Chi-Chi, padre de Son Gohan y Son Goten, a su vez también es el abuelo de Pan y ancestro de Son Goku Jr. Originalmente enviado a la Tierra como un infante volador con la misión de conquistarla. Sin embargo, el caer por un barranco le proporcionó un brutal golpe que si bien casi lo mata, este alteró su memoria y anuló todos los instintos violentos de su especie, lo que lo hizo crecer con un corazón puro y bondadoso, pero conservando todos los poderes de su raza.", biography: "El nombre de ¨Goku¨ significa ¨despertado del vacío¨; la sílaba ¨Go¨ significa ¨Ilustración¨, y la sílaba ¨Ku¨ significa ¨cielo¨ o ¨vacío¨. Su nombre completo ¨Son Goku¨, es una derivación al japonés del nombre ¨Sun Wukong¨, el protagonista principal en la leyenda china Viaje al Oeste, en la que se basa vagamente Goku.")
    
    return BasicCharacterCardView(character: character)
}
