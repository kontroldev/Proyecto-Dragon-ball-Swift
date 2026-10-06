//
//  ContentView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//
import SwiftUI

struct ContentView: View {
    @Environment(SessionStore.self) private var session
    @State private var showsLogin = false

    @State private var favoritesViewModel: FavoritesViewModel = FavoritesViewModel()

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            TabView {
                WikiView()
                    .tabItem {
                        Label("Wiki", systemImage: "books.vertical.fill")
                            .tint(.accentColor)
                    }
                SongListView(songs: SongsModel())
                    .tabItem {
                        Label("Reproductor", systemImage: "music.note")
                            .tint(.accentColor)
                    }
                GamesView()
                    .tabItem {
                        Label("Juegos", systemImage: "gamecontroller.fill")
                            .tint(.accentColor)
                    }
                ProfileSettingsView()
                    .tabItem {
                        Label("Opciones", systemImage: "gearshape.2.fill")
                            .tint(.accentColor)
                    }
            }
        }
        .environment(favoritesViewModel)
        .task(id: session.userID) {
            favoritesViewModel.resetForSession()
            await favoritesViewModel.getFavoriteCharactersIDs()
        }
        .sheet(isPresented: $showsLogin) { LoginView() }
        .alert("Favoritos", isPresented: $favoritesViewModel.showError) {
            if session.userID == nil {
                Button("Iniciar sesión") { showsLogin = true }
            }
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(favoritesViewModel.errorMessage)
        }
    }
}
#Preview {
    ContentView().environment(SessionStore())
}
