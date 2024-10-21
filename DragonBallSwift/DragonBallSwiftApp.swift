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
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
//            switch loginFlowState {
//            case .loggedOut:
//                LoginView()
//                    .preferredColorScheme(isDarkMode ? .dark : .light)
//            case .loggedIn:
//                ContentView()
//                    .preferredColorScheme(isDarkMode ? .dark : .light)
//            }
        }
    }
}
