//
//  GoogleSignInService.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 28-07-24.
//

import Foundation
@preconcurrency import GoogleSignIn
import UIKit

@MainActor
final class GoogleService {
    /// Devuelve false cuando el usuario cancela el inicio de sesión con Google.
    func authenticate() async throws -> Bool {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            throw NSError(domain: "Falta GIDClientID en Info.plist", code: 0)
        }
        let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        guard var presenter = scene?.windows.first(where: \.isKeyWindow)?.rootViewController else {
            throw NSError(domain: "No se puede mostrar el inicio de sesión", code: 0)
        }
        while let presented = presenter.presentedViewController { presenter = presented }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        let result: GIDSignInResult
        do {
            result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
        } catch {
            if (error as NSError).domain == kGIDSignInErrorDomain
                && (error as NSError).code == GIDSignInError.Code.canceled.rawValue
            {
                return false
            }
            throw error
        }
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "Google no ha devuelto credenciales válidas", code: 0)
        }
        try await SessionStore.shared.signIn(idToken: idToken)
        return true
    }

    func logout() {
        GIDSignIn.sharedInstance.signOut()
    }
}
