//
//  ExampleView.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import SwiftUI

/// Vista de ejemplo que muestra listas de personajes y planetas.
struct ExampleView: View {

    // ViewModel para manejar la lógica de los personajes.
    @State var allCheractersViewModel: AllCheractersViewModel
    // ViewModel para manejar la lógica de los planetas.
    @State var allPlanetsViewModel: AllPlanetsViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                // Sección para mostrar la lista de personajes.
                Section("Lista de Personajes"){
                    List(allCheractersViewModel.allCheracters, id: \.id){ item in
                        HStack{
                            // Carga asíncrona de la imagen del personaje.
                            AsyncImage(url: URL(string: item.image)){ image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            }placeholder: {
                                ProgressView()
                            }.frame( width: 23,  height: 70)
                                .padding()
                            
                            // Nombre del personaje.
                            Text(item.name).font(.title2).bold()
                        }
                    }
                }
                
                // Sección para mostrar la lista de planetas.
                Section("Lista de Planetas"){
                    if let planets = allPlanetsViewModel.allPlanets {
                        List(planets.items, id:\.id){ item in
                            HStack {
                                // Carga asíncrona de la imagen del planeta.
                                AsyncImage(url: URL(string: item.image)){ image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }.frame(width: 50)
                                    .padding()
                                
                                // Nombre del planeta.
                                Text(item.name).font(.title2).bold()
                            }
                        }
                    }
                }
                
            }.navigationTitle("Vista de Ejemplo")
        }
    }
}

#Preview {
    ExampleViewBuilder().build()
}
