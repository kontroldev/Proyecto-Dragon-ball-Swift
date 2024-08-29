//
//  SongsPlayerViewModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import AVFoundation
import ActivityKit
import AVKit
import Foundation
import MediaPlayer

//Extensión para convertir el tiempo actual que lleva la canción en minutos y segundos
extension TimeInterval {
    func toTimeString() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
class SongsPlayerViewModel: ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentSongIndex = 0 {
        didSet {
            currentSong = songs[currentSongIndex]
        }
    }
    @Published var currentSong: URL?

    private var playTimer: Timer?
    private var player: AVAudioPlayer?
    private var isPaused = false
    
    let songsModel = SongsModel()
    var songs: [URL] = []
    init() {
        self.songs = songsModel.arrayOfSongs.compactMap { songName in
            SongsViewModel(name: songName.name).getURL()
        }
        self.currentSong = songs.first
 
    }

    public func play (withURL url: URL? = nil) {
        if let player = player, isPaused {
            player.play()
            startTimer()
            isPaused = false
        } else {
            let songURL = url ?? songs[currentSongIndex]
            do {
                player = try AVAudioPlayer(contentsOf: songURL)
                player?.prepareToPlay()
                duration = player?.duration ?? 0
                player?.play()
                startTimer()
            } catch {
                print("Error al reproducir la canción: \(error.localizedDescription)")
            }
        }
    }
    public func stop() {
        player?.stop()
        player = nil
        stopTimer()
        currentTime = 0
        print("Función Stop pulsada")
    }
    public func pause() {
        player?.pause()
        stopTimer()
        isPaused = true
    }
    public func nextSong(){
        let wasPlaying = !isPaused
        stop()
        currentSongIndex = (currentSongIndex + 1) % songs.count
        if wasPlaying {
            play()
        } else {
            let songURL = songs [currentSongIndex]
            do {
                player = try AVAudioPlayer(contentsOf: songURL)
                player?.prepareToPlay()
                duration = player?.duration ?? 0
            } catch {
                print("Error al cargar la canción: \(error.localizedDescription)")
            }
        }
        
    }
    public func previousSong() {
        let wasPlaying = !isPaused
        guard currentSongIndex > 0 else {
            stop()
            if wasPlaying {
                play()
            }
            
            return
        }
        stop()
        currentSongIndex -= 1
        if wasPlaying {
            play()
        }
    }
    //Funciones (3 siguientes) para obtener el tiempo transcurrido en la reproducción
    //Comienza a contar el tiempo
    private func startTimer() {
        playTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }
    }
    //Detiene el temporizador
    private func stopTimer() {
        playTimer?.invalidate()
        playTimer = nil
    }
    //Actualiza el tiempo actual
    private func updateCurrentTime() {
        if let player = player {
            currentTime = player.currentTime
        }
    }
}
