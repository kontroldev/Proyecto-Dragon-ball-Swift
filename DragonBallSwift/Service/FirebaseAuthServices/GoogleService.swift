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


/// Envoltorio para pasar de forma segura un closure no-Sendable a través de una frontera `@Sendable`.
/// El SDK de Google Sign-In invoca su completion de forma serial en el hilo principal, por lo que no hay una condición de carrera real.
private struct UncheckedSendableBox<Value>: @unchecked Sendable {
    let value: Value
}

final class GoogleService {
    var showError = false
    var errorMessage: String = ""
    var navigateHome = false
    
    /// Método para autenticar al usuario mediante Google Sign-In y Firebase.
    ///
    /// Esta función inicia el flujo de autenticación de Google Sign-In para obtener las credenciales del usuario. Si el proceso es exitoso, utiliza estas credenciales para autenticar al usuario en Firebase.
    ///
    /// - Parameter completion: Un closure que se ejecutará al finalizar la autenticación. El closure recibe un `Result` que indica si la autenticación fue exitosa (`success(true)`) o si ocurrió un error (`failure(Error)`). El error puede ser de varios tipos, incluyendo:
    ///     - `NSError(domain: "Missing clientID", code: 0, userInfo: nil)`: Indica que falta el ID de cliente de Firebase.
    ///     - `NSError(domain: "No presenting view controller", code: 0, userInfo: nil)`: Indica que no se pudo obtener el controlador de vista para presentar la interfaz de Google Sign-In.
    ///     - `NSError(domain: "Authentication failed", code: 0, userInfo: nil)`: Indica que la autenticación con Google o Firebase falló.
    ///     - Cualquier otro error devuelto por el SDK de Google Sign-In o Firebase Auth.
    @MainActor func authenticate(completion: @escaping(Result<Bool, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Falta el client ID de Firebase", code: 0, userInfo: nil)))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(.failure(NSError(domain: "No se puede mostrar la vista de inicio de seisón de Google", code: 0, userInfo: nil)))
            return
        }
        
        let boxedCompletion = UncheckedSendableBox(value: completion)
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { user, error in
            if let error = error {
                print(error.localizedDescription)
                //Si el usuario cancela la acción de inciar con google se devuelve un false
                boxedCompletion.value(.success(false))
                return
            }

            guard let authentication = user?.user, let idToken = user?.user.idToken else {
                boxedCompletion.value(.failure(NSError(domain: "Falló la autenticación", code: 0, userInfo: nil)))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    boxedCompletion.value(.failure(error))
                } else {
                    boxedCompletion.value(.success(true))
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
