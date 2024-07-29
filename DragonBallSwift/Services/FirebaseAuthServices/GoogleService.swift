//
//  GoogleSignInService.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

class GoogleService: ObservableObject {
    
    @AppStorage("LoginFlowState") private var loginFlowState = UserLoginState.login
    var showError = false
    var errorMessage: String = ""
    var navigateHome = false
    
    func authenticate() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { user, error in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = "Error al intentar iniciar con Google: \(error.localizedDescription)"
                self.showError = true
                return
            }
            
            guard let authentication = user?.user, let idToken = user?.user.idToken else {
                return
            }
            
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                guard let _ = authResult?.user, error == nil else {
                    self.errorMessage = "Error al intentar iniciar sesión con Google"
                    self.loginFlowState = .login
                    self.showError = true
                    return
                }
            }
            
            self.loginFlowState = .checkForAnAccount
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

