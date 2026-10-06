//
//  PlayerView.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import ActivityKit
import MediaPlayer
import SwiftUI

struct VolumeView: UIViewRepresentable {

    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView()
        let emptyImage = UIImage()
        volumeView.setVolumeThumbImage(emptyImage, for: .normal)
        for subview in volumeView.subviews {
            if let slider = subview as? UISlider {
                slider.transform = CGAffineTransform(scaleX: 1.0, y: 1.5)
                slider.maximumTrackTintColor = UIColor.gray
            }
        }
        return volumeView
    }
    func updateUIView(_ view: MPVolumeView, context: Context) {}
}
struct PlayerView: View {

    var song: URL?
    var songName: String
    @ObservedObject var songsPlayer: SongsPlayerViewModel

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color("BackgroundColor")], center: .center, startRadius: 30, endRadius: 380
            )
            .ignoresSafeArea()

            if let currentSong = songsPlayer.currentSong {
                let songName = currentSong.lastPathComponent
                let imageName = songName.replacingOccurrences(of: ".mp3", with: "")
                Image(imageName)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .opacity(0.5)
                    .blur(radius: 25)
                VStack(alignment: .center, spacing: 10) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340, height: 340)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                        .padding(.top, 30)
                    Spacer()
                        .frame(height: 30)
                    Text(imageName)
                        .font(.title)
                        .foregroundStyle(.white)
                    ProgressView(value: songsPlayer.currentTime, total: max(1, songsPlayer.duration))
                        .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                        .frame(height: 20)
                        .padding(.horizontal, 30)
                    Text(String(songsPlayer.currentTime.toTimeString()))
                        .foregroundStyle(.gray)
                    Spacer()
                        .frame(height: 8)
                    HStack {
                        Button {
                            songsPlayer.previousSong()
                        } label: {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(width: 45, height: 25)
                        }
                        .padding()
                        .accessibilityLabel("Canción anterior")
                        Button {
                            if songsPlayer.isPlaying {
                                songsPlayer.pause()
                            } else {
                                songsPlayer.play()
                            }
                        } label: {
                            Image(systemName: songsPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .frame(width: 30, height: 40)
                        }
                        .padding()
                        .accessibilityLabel(songsPlayer.isPlaying ? "Pausar" : "Reproducir")
                        Button {
                            songsPlayer.nextSong()
                        } label: {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(width: 45, height: 25)
                        }
                        .padding()
                        .accessibilityLabel("Canción siguiente")
                    }
                    Spacer()
                        .frame(height: 8)
                    HStack(alignment: .center) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.white)
                            .padding(.leading, 30)
                        ZStack {
                            GeometryReader { geometry in
                                VolumeView()
                                    .frame(width: geometry.size.width * 1, height: 20)
                                    .opacity(0.8)
                            }
                            .frame(height: 20)
                        }

                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.white)
                            .padding(.trailing, 30)
                            .padding(.leading, 2)
                    }
                    Spacer()
                }
                .onAppear {
                    if let song = song, let songIndex = songsPlayer.songs.firstIndex(of: song) {
                        songsPlayer.currentSongIndex = songIndex
                    }
                    songsPlayer.play(withURL: song)
                }
                .onDisappear {
                    songsPlayer.stop()
                }
            } else {
                ContentUnavailableView("No hay audio disponible", systemImage: "music.note")
            }
        }
        .overlay(alignment: .bottom) {
            if let error = songsPlayer.errorMessage { Text(error).padding() }
        }
    }
}

#Preview {
    if let url = Bundle.main.url(forResource: "Dragon Ball GT", withExtension: "mp3") {
        PlayerView(song: url, songName: "Dragon Ball GT", songsPlayer: SongsPlayerViewModel())
    } else {
        PlayerView(song: nil, songName: "test", songsPlayer: SongsPlayerViewModel())
    }
}
