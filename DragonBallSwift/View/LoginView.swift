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
    @State private var kiRadius: CGFloat = 10.0
    @State private var isAnimmating = false
    
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
            Image("Dragon1").resizable()
                .scaledToFit()
                .shadow(color: .green, radius: kiRadius)
                .offset(y: -55)
                .overlay{
                    Image("LogoBall").resizable()
                        .scaledToFit()
                    // .frame(width: 300, height: 300)
                        .shadow(color: .yellow, radius: kiRadius, x: 0, y: 0)
                        .offset(y: 155)
                        .overlay{
                            Text("App")
                                .font(.custom("SaiyanSans", size: 60).bold()).foregroundStyle(.yellow)
                                .offset(x: 120, y: 310)
                                .shadow(color: .black, radius: 0, x: 1, y: 1)
                                .shadow(color: .white, radius: 0, x: -1, y: -1)
                                .shadow(color: .yellow, radius: 10)
                        }
                }
                .onAppear{
                    withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)){
                        self.kiRadius = 30.0
                    }
                }
                
            
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
                    .background(Color.cardColorEX)
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
        .background(LinearGradient(
            gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
            startPoint: .top,
            endPoint: .bottom
        ))
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
