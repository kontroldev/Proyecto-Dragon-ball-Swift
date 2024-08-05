//
//  PlayerView.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import SwiftUI

struct PlayerView: View {
    
    @State private var isPlaying = false
    
    var song: URL?
    @ObservedObject var songsPlayer: SongsPlayerViewModel
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Reproductor") //Establecer el nombre de la canción
                    .font(.title)
                    .foregroundStyle(.white)
                Image("DragonBallZ")
                    .scaledToFit()
                    .padding(.vertical, 30)
                Spacer()
                ProgressView(value: songsPlayer.currentTime, total: songsPlayer.duration)
                    .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                    .padding(.horizontal, 50)
                    .padding(.top, 50)
                Text(String(songsPlayer.currentTime.toTimeString()))
                    .foregroundStyle(.gray)
                HStack{
                    Button{
                        if isPlaying {
                            songsPlayer.pause()
                            isPlaying = false
                        } else {
                            if let url = song {
                                songsPlayer.play(withURL: url)
                            }
                            isPlaying = true
                        }
                    }label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    Button{
                        songsPlayer.stop()
                        isPlaying = false
                    }label: {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                }
                Spacer()
                    .frame(height: 150)
            }
            .safeAreaInset(edge: .top, spacing: 30) {
                Color.clear.frame(height: 50)
            }
            .onAppear{songsPlayer.play(withURL: song!)}
            .onDisappear{
                songsPlayer.stop()
                isPlaying = false
            }
        }
    }
}

#Preview {
    if let url = Bundle.main.url(forResource: "Dragon Ball GT", withExtension: "mp3") {
        PlayerView(song: url, songsPlayer: SongsPlayerViewModel())
            } else {
                PlayerView(song: nil, songsPlayer: SongsPlayerViewModel())
            }

}
