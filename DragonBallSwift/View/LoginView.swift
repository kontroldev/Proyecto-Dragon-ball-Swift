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
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Dragon Ball App")
                .font(.title)
            
            Spacer()
            
            
            Button {
                loginViewModel.signInWithGoogle()
            } label: {
                Text("Iniciar con Google")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .alert("Error", isPresented: $loginViewModel.showError) {
            Button("Ok", role: .cancel) { }
        }
    }
}

#Preview {
    LoginView()
}
