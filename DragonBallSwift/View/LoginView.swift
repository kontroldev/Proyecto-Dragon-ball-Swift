//
//  LoginView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image("LogoBall")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280)
                .accessibilityHidden(true)
            Text("Guarda tus personajes favoritos")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text("Puedes explorar la wiki y jugar sin iniciar sesión.")
                .multilineTextAlignment(.center)
            Button {
                Task {
                    if await viewModel.signInWithGoogle() { dismiss() }
                }
            } label: {
                Label("Continuar con Google", systemImage: "person.crop.circle")
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
            if viewModel.isLoading { ProgressView("Iniciando sesión…") }
            Button("Ahora no", role: .cancel) { dismiss() }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .alert("No se pudo iniciar sesión", isPresented: $viewModel.showError) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview { LoginView() }
