//
//  LoginViewModel.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 29-07-24.
//

import Foundation

@Observable
class LoginViewModel {
    private let googleService = GoogleService()
    
    var isLoginSuccess: Bool = false
    var showError: Bool = false
    
    func signInWithGoogle() {
        googleService.authenticate { result in
            switch result {
            case .success(let success):
                self.isLoginSuccess = success
            case .failure(let error):
                print(error)
                self.showError = true
            }
        }
    }
}
