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


final class GoogleService {
    var showError = false
    var errorMessage: String = ""
    var navigateHome = false
    
    func authenticate(completion: @escaping(Result<Bool, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Missing clientID", code: 0, userInfo: nil)))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(.failure(NSError(domain: "No presenting view controller", code: 0, userInfo: nil)))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { user, error in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = "Error al intentar iniciar con Google: \(error.localizedDescription)"
                self.showError = true
                return
            }
            
            guard let authentication = user?.user, let idToken = user?.user.idToken else {
                completion(.failure(NSError(domain: "Authentication failed", code: 0, userInfo: nil)))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = "Error al intentar iniciar sesión con Google: \(error.localizedDescription)"
                    self.showError = true
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
