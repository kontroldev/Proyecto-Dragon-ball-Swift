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
    @StateObject private var songsPlayer = SongsPlayerViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Canciones")
                    .font(.title)
                    .foregroundStyle(Color.textColor)
                    .fontWeight(.bold)
                ScrollView {
                    ForEach(songs.arrayOfSongs, id: \.self) { song in
                        NavigationLink(
                            destination: PlayerView(
                                song: song.url, songName: song.name, songsPlayer: songsPlayer)
                        ) {
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
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.cardColorEX, .cardColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2))
                            )
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                                    startPoint: .top,
                                    endPoint: .bottom

                                )
                            )
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(color: .white, radius: 0.5)
                        }
                        .disabled(song.url == nil)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                    startPoint: .top,
                    endPoint: .bottom

                ))

        }
    }
}

#Preview { SongListView(songs: SongsModel()) }
