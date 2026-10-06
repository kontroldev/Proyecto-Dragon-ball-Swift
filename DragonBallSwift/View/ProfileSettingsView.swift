//
//  ProfileSettingsView.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 9/9/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(SessionStore.self) private var session
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showsLogin = false
    @State private var showsError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Cuenta") {
                    if session.userID == nil {
                        Button("Iniciar sesión") { showsLogin = true }
                    } else {
                        Button("Cerrar sesión", role: .destructive) {
                            Task {
                                do { try await session.signOut() } catch {
                                    errorMessage = error.localizedDescription
                                    showsError = true
                                }
                            }
                        }
                    }
                }
                Section("Apariencia") {
                    Toggle("Modo oscuro", isOn: $isDarkMode)
                }
                Section("Quiénes somos") {
                    Text(
                        "Proyecto colaborativo para aprender Swift y SwiftUI con una wiki y minijuegos de Dragon Ball."
                    )
                    Text("KontrolDev · ManuelCBR · Yeikobu · Lordzzz")
                }
            }
            .navigationTitle("Opciones")
            .sheet(isPresented: $showsLogin) { LoginView() }
            .alert("No se pudo cerrar la sesión", isPresented: $showsError) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview { ProfileSettingsView().environment(SessionStore()) }
