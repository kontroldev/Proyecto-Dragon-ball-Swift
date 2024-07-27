//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 27/7/24.
//

import SwiftUI

struct ViewDetails: View {
    
    // Recibimos los datos de la API, no lo inicializamos.
    @State var Caracter: CharactersModel
    
    var body: some View {
        ZStack {
            
            //Esto crea el fondo de color con gradientes y el color por defecto de la App.
            RadialGradient(colors: [.red, Color("BackgroundColor")], center: .center, startRadius: 30, endRadius: 380)
                .ignoresSafeArea()
            
            ScrollView {
                AsyncImage(url: URL(string: Caracter.image)) { image in
                    image
                        .resizable()
                        .frame(width: 400, height: 400, alignment: .center)
                        .offset(y: 15) // Ponemos un 15, para bajar la imagen
                        .shadow(color: .yellow, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                } placeholder: {
                    ProgressView()
                }
                HStack {
                    Text(Caracter.name).font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 50)
                VStack {
                    Text(Caracter.description).font(.title3)
                        .foregroundStyle(.white)
                    
                }
                // Ponemos un tamaño de 30 adaptado para los bordes de la descripcion.
                .padding(30)
            }
        }
        
        
        
    }
}

#Preview {
    @State var character = CharactersModel(id: "666808ce2a01878ca18a9f6d", name: "Son Goku", genre: "Masculino", race: "Saiyajin", image: "https://apidragonball.vercel.app/static/images/GokuPeque.png", planet: "Vegeta, (criado en la tierra)", description: "Son Goku (孫そん悟ご空くう Son Gokū¿?) es el protagonista principal del manga y anime de Dragon Ball creado por Akira Toriyama. Su nombre real y de nacimiento es Kakarotto (カカロット¿?) y es uno de los pocos saiyanos que lograron sobrevivir a la destrucción total del Planeta Vegeta del Universo 7. Es el segundo hijo de Bardock y Gine, hermano menor de Raditz, nieto adoptivo de Son Gohan, esposo de Chi-Chi, padre de Son Gohan y Son Goten, a su vez también es el abuelo de Pan y ancestro de Son Goku Jr. Originalmente enviado a la Tierra como un infante volador con la misión de conquistarla. Sin embargo, el caer por un barranco le proporcionó un brutal golpe que si bien casi lo mata, este alteró su memoria y anuló todos los instintos violentos de su especie, lo que lo hizo crecer con un corazón puro y bondadoso, pero conservando todos los poderes de su raza.", biography: "El nombre de ¨Goku¨ significa ¨despertado del vacío¨; la sílaba ¨Go¨ significa ¨Ilustración¨, y la sílaba ¨Ku¨ significa ¨cielo¨ o ¨vacío¨. Su nombre completo ¨Son Goku¨, es una derivación al japonés del nombre ¨Sun Wukong¨, el protagonista principal en la leyenda china Viaje al Oeste, en la que se basa vagamente Goku.")
    
    return ViewDetails(Caracter: character)
    
    
    
}
