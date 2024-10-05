//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 27/7/24.
//

import SwiftUI

struct SagasViewDetails: View {
    //Logica de reconocimiento de colores
    @State var crImages = CRImages()
    
    // Recibimos los datos de la API, no lo inicializamos.
    @State var character: CharactersModel
    
    @Binding var logoDB: String
    
    var body: some View {
        ZStack {
            
            //Esto crea el fondo de color con gradientes y el color por defecto de la App.
            RadialGradient(colors: [Color.backgroundColorEX, Color.backgroundColor], center: .center, startRadius: 30, endRadius: 380)
                .ignoresSafeArea()
            
            ScrollView {
                Circle()
                    .frame(width: 300, height: 300)
                    .blur(radius: 90)
                    .foregroundStyle(crImages.mostVibrantColor)
                    .overlay{
                        AsyncImage(url: URL(string: character.image)) { image in
                            image
                                .resizable()
                                .frame(width: 400, height: 400, alignment: .center)
                                .offset(y: 15) // Ponemos un 15, para bajar la imagen
                                .onAppear{
                                    if let uiImage = image.asUIImage() {
                                        crImages.detectColors(in: uiImage)
                                    }
                                }
                                .padding()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }.padding(.bottom, 40)
                HStack {
                    Text(character.name).font(.custom("SaiyanSans", size: 30))
                        .bold()
                        .foregroundStyle(.yellow)
                    Spacer()
                    Image(logoDB)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                    
                }

                .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Genero: ").font(.title2 .bold()).foregroundStyle(.cyan) + Text(character.genre)
                        Text("Raza: ").font(.title2 .bold()).foregroundStyle(.yellow) + Text(character.race)
                        Text("Planeta: ").font(.title2 .bold()).foregroundStyle(.green) + Text(character.planet)
                    }
                        .padding(.bottom)
                    Text(character.description).font(.title3) 
                        .foregroundStyle(Color.textColor)
                    
                }
                // Ponemos un tamaño de 30 adaptado para los bordes de la descripcion.
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    @Previewable @State var mock = Mocks()
    
    @Previewable @State var logoDB = "DBLogo"
    return SagasViewDetails(character: mock.character, logoDB: $logoDB)
    
}
