//
//  ContentView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 29/5/24.
//
//  ⚠️ ARREGLADO:
//  1. La pestaña decía "Obciones" en vez de "Opciones".
//  2. Había un ZStack anidado pintando dos fondos distintos
//     (Color.backgroundColorEX y Color("BackgroundColor")), uno encima
//     del otro. El de abajo queda completamente tapado por el de arriba,
//     así que era código muerto: se deja solo el fondo que realmente se ve.

import SwiftUI

struct ContentView: View {

    @State private var favoritesViewModel: FavoritesViewModel = FavoritesViewModel()

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            TabView {
                WikiView()
                    .environment(favoritesViewModel)
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
                        // FIX: "Obciones" -> "Opciones"
                        Label("Opciones", systemImage: "gearshape.2.fill")
                            .tint(.accentColor)
                    }
            }
        }
    }
}
#Preview {
    ContentView()
}
