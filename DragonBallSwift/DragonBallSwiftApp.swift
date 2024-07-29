//
//  DragonBallSwiftApp.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//

import SwiftUI

@main
struct DragonBallSwiftApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("LoginFlowState") private var loginFlowState = UserLoginState.loggedOut
    
    var body: some Scene {
        WindowGroup {
            switch loginFlowState {
            case .loggedOut:
                LoginView()
                    .preferredColorScheme(.dark)
            case .loggedIn:
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
