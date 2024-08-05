//
//  SongsPlayerViewModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import AVKit
import Foundation

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
    private var timer: Timer?
    private var player: AVAudioPlayer?
    private var isPaused = false
    
    func play (withURL url: URL) {
        
        if let player = player, isPaused {
            player.play()
            startTimer()
            isPaused = false
        } else {
            player = try! AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 0
            player?.play()
            startTimer()
        }
    }
    func stop () {
        player?.stop()
        player = nil
        stopTimer()
        currentTime = 0
    }
    func pause () {
        player?.pause()
        stopTimer()
        isPaused = true
    }
    //Funciones (3 siguientes) para obtener el tiempo transcurrido en la reproducción
    //Comienza a contar el tiempo
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }
    }
    //Detiene el temporizador
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    //Actualiza el tiempo actual
    private func updateCurrentTime() {
        if let player = player {
            currentTime = player.currentTime
        }
    }
    
}
