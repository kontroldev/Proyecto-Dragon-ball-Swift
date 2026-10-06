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
    @State private var session = SessionStore.shared
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .task { await session.startListening() }
        }
    }
}
