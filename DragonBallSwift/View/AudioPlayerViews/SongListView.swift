//
//  SongListView.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import AVKit
import SwiftUI

struct SongListView: View {
    
    let songs: SongsModel
    @ObservedObject var songsPlayer = SongsPlayerViewModel()
    @State private var isShowingPlayer = false
    @State private var showPlayerSheet = false
    @State private var selectedSong: SongsViewModel? = nil
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Canciones")
                    .font(.title)
                    .foregroundStyle(Color.textColor)
                    .fontWeight(.bold)
                ScrollView{
                    ForEach(songs.arrayOfSongs, id: \.self) { song in
                        NavigationLink(destination: PlayerView(song: song.getURL(),songName: song.name, songsPlayer: songsPlayer)){
                            HStack {
                                Image("\(song.name)")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("\(song.name)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color.textColor)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2))
                            )
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                                startPoint: .top,
                                endPoint: .bottom
                                
                            ))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(color: .white, radius: 0.5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
                
            ))
            
            

        }
        // ---------------------------------
        /*NavigationStack {
            VStack {
                Text("Canciones")
                    .font(.title)
                    .foregroundStyle(.accent)
                    .fontWeight(.bold)
                ScrollView {
                    ForEach(songs.arrayOfSongs, id: \.self) { song in
                        Button(action: {
                            selectedSong = song
                            showPlayerSheet = true
                        }) {
                            HStack {
                                Image("\(song.name)")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("\(song.name)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2))
                            )
                            .background(Color("BackgroundColor"))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .sheet(isPresented: $showPlayerSheet) {
                if let selectedSong = selectedSong {
                    PlayerView(song: selectedSong.getURL(), songName: selectedSong.name, songsPlayer: songsPlayer)
                        .ignoresSafeArea()
                }
            }
        }*/
    }
}

#Preview {
    SongListView(songs: SongsModel())
}
