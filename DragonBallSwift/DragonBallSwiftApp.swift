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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
