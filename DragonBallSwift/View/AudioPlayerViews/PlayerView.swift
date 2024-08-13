//
//  PlayerView.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import ActivityKit
import SwiftUI

struct PlayerView: View {
    
    @State private var isPlaying = false
    @State private var activityIdentifier: String = ""
    
    var song: URL?
    var songName: String
    @ObservedObject var songsPlayer: SongsPlayerViewModel
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text(songName) //Establecer el nombre de la canción
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
                            updateDynamicIsland()
                        } else {
                            if let url = song {
                                songsPlayer.play(withURL: url)
                            }
                            isPlaying = true
                            do{
                                if activityIdentifier.isEmpty{
                                    activityIdentifier = try AudioPlayerActivityUseCaseViewModel.startActivity(songName: songName)
                                } else {
                                    updateDynamicIsland()
                                }
                            }catch{
                                print(error.localizedDescription)
                            }
                            updateDynamicIsland()
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
                        Task{
                            await AudioPlayerActivityUseCaseViewModel.endActivity(withActivityIdentifier:activityIdentifier)
                        }
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
            .onAppear{
                songsPlayer.play(withURL: song!)
                isPlaying = true
                do{
                    activityIdentifier = try AudioPlayerActivityUseCaseViewModel.startActivity(songName: songName)
                }catch{
                    print(error.localizedDescription)
                }
            }
            .onChange(of: songsPlayer.currentTime){
                updateDynamicIsland()
            }
            .onDisappear{
                songsPlayer.stop()
                isPlaying = false
            }
        }
    }
    func updateDynamicIsland (){
        Task { 
            await AudioPlayerActivityUseCaseViewModel.updateActivity(activityIdentifier: activityIdentifier, songName: songName, isPlaying: isPlaying, url: song, currentTime: songsPlayer.currentTime, duration: songsPlayer.duration)
        }
    }
}

#Preview {
    if let url = Bundle.main.url(forResource: "Dragon Ball GT", withExtension: "mp3") {
        PlayerView(song: url,songName: "test", songsPlayer: SongsPlayerViewModel())
            } else {
                PlayerView(song: nil, songName: "test", songsPlayer: SongsPlayerViewModel())
            }

}
