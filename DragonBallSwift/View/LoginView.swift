//
//  LoginView.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    
    @State private var loginViewModel = LoginViewModel()
    @State private var isSignInWithGoogleButtonPressed: Bool = false
    
    @AppStorage("LoginFlowState") private var loginFlowState = UserLoginState.loggedOut
    
    var body: some View {
        ZStack {
            switch loginFlowState {
            case .loggedOut:
                MainLoginView()
            case .loggedIn:
                ContentView()
            }
        }
    }
    
    /// Vista que crea la pantalla de login, la cual contiene el botón de incial con Google
    @ViewBuilder
    func MainLoginView() -> some View {
        VStack {
            Spacer()
            
            Text("Dragon Ball App")
                .font(.title)
            
            Spacer()
            
            VStack {
                Button {
                    isSignInWithGoogleButtonPressed = true
                    
                    loginViewModel.signInWithGoogle { success in
                        if success {
                            loginFlowState = .loggedIn
                        } else {
                            loginFlowState = .loggedOut
                            isSignInWithGoogleButtonPressed = false
                        }
                    }
                } label: {
                    HStack {
                        Image("GoogleLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        
                        Text("Continuar con Google")
                            .fontWeight(.medium)
                    }
                    .padding(8)
                    .background(Color.cardColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    }
                    .shadow(radius: 4)
                }
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .overlay {
            if isSignInWithGoogleButtonPressed {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .alert("Error al iniciar con Google", isPresented: $loginViewModel.showError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(loginViewModel.errorMessage)
        }
    }
}

#Preview {
    LoginView()
}
