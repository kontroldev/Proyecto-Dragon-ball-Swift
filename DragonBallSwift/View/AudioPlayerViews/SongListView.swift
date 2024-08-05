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
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Canciones")
                    .font(.title)
                    .foregroundStyle(.accent)
                    .fontWeight(.bold)
                ScrollView{
                    ForEach(songs.arrayOfSongs, id: \.self) { song in
                        NavigationLink(destination: PlayerView(song: song.getURL(), songsPlayer: SongsPlayerViewModel())){
                            HStack {
                                Text("\(song.name)")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color("CardColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
        }
    }
}

#Preview {
    SongListView(songs: SongsModel())
}
