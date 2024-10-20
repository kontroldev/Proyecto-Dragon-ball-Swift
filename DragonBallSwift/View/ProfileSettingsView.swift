//
//  ProfileSettingsView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 9/9/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    @AppStorage("LoginFlowState") private var loginFlowState = UserLoginState.loggedOut
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack{
            VStack{
                    // Cierra la sesion
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(height: 60)
                        .overlay{
                            // Elementos de formulario ....
                            HStack{
                                Button(action: {
                                    loginFlowState = .loggedOut}
                                ) {
                                    Label("Cerrar Sesión", systemImage: "power")
                                        .foregroundColor(.red)
                                }
                                Spacer()
                            }.padding()
                        }.padding(.horizontal)
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(height: 60)
                        .overlay{
                            // Cambia entre modo oscuro y modo claro
                            Toggle(isOn: $isDarkMode) {
                                Label(isDarkMode ? "Modo Claro" : "Modo Oscuro", systemImage: isDarkMode ? "sun.max.fill" : "moon.fill")
                            }.padding()
                            
                        }.padding(.horizontal)
                
                Form{
 
                    Section("Quienes somos"){
                        
                        Text("Participantes del proyecto: ").font(.title2.bold())
                        Text("""
                              KontrolDev
                              ManuelCBR
                              Yeikobu
                              Lordzzz
                            """)
                        Text("Objetivos del proyecto:").font(.title2.bold())
                        Text("Ojetivos .....")
                    }
                    
                }.scrollContentBackground(.hidden)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                
                
            }
            .navigationTitle("Opciones:")
            .scrollContentBackground(.hidden)
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
        }
    }
}

#Preview {
    ProfileSettingsView()
}
