//
//  SongsPlayerViewModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import AVFoundation
import ActivityKit
import Combine
import Foundation

extension TimeInterval {
    func toTimeString() -> String {
        let seconds = max(0, Int(self))
        return String(format: "%02i:%02i", seconds / 60, seconds % 60)
    }
}

@MainActor
final class SongsPlayerViewModel: ObservableObject {
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    @Published private(set) var isPlaying = false
    @Published private(set) var errorMessage: String?
    @Published var currentSongIndex = 0 {
        didSet { currentSong = songs.indices.contains(currentSongIndex) ? songs[currentSongIndex] : nil }
    }
    @Published private(set) var currentSong: URL?
    let songs: [URL]
    private var activityIdentifier: String?
    private var loadedURL: URL?
    private var player: AVAudioPlayer?
    private var progressTask: Task<Void, Never>?

    init(songs: [URL]? = nil) {
        self.songs = songs ?? SongsModel().arrayOfSongs.compactMap { $0.url }
        currentSong = self.songs.first
    }

    func play(withURL url: URL? = nil) {
        errorMessage = nil
        guard let url = url ?? currentSong else {
            errorMessage = "No se encontró el archivo de audio."
            return
        }
        do {
            if player == nil || loadedURL != url {
                stop()
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                currentSong = url
                loadedURL = url
            }
            duration = player?.duration ?? 0
            isPlaying = player?.play() ?? false
            if isPlaying {
                startProgressUpdates()
                updateActivity()
            }
        } catch {
            stop()
            errorMessage = "No se pudo reproducir la canción."
        }
    }

    func stop() {
        progressTask?.cancel()
        progressTask = nil
        player?.stop()
        player = nil
        loadedURL = nil
        if let activityIdentifier { Task { await PlaybackLiveActivity.end(id: activityIdentifier) } }
        activityIdentifier = nil
        currentTime = 0
        duration = 0
        isPlaying = false
    }

    func pause() {
        player?.pause()
        isPlaying = false
        progressTask?.cancel()
        progressTask = nil
        currentTime = player?.currentTime ?? currentTime
        updateActivity()
    }

    func nextSong() {
        guard !songs.isEmpty else { return }
        selectSong(at: (currentSongIndex + 1) % songs.count)
    }

    func previousSong() {
        guard !songs.isEmpty else { return }
        selectSong(at: max(0, currentSongIndex - 1))
    }

    private func selectSong(at index: Int) {
        let shouldPlay = isPlaying
        stop()
        currentSongIndex = index
        if shouldPlay { play() }
    }

    private func updateActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled, let currentSong else { return }
        let state = AudioPlayerAttributesModel.ContentState(
            songName: currentSong.deletingPathExtension().lastPathComponent,
            url: currentSong, currentTime: player?.currentTime ?? 0, duration: duration,
            startedAt: isPlaying ? .now.addingTimeInterval(-(player?.currentTime ?? 0)) : nil,
            isPlaying: isPlaying
        )
        if let activityIdentifier {
            Task { await PlaybackLiveActivity.update(id: activityIdentifier, state: state) }
        } else {
            // Una actividad opcional no debe interrumpir la reproducción si falla.
            activityIdentifier = try? PlaybackLiveActivity.start(state: state)
        }
    }

    private func startProgressUpdates() {
        progressTask?.cancel()
        progressTask = Task { [weak self] in
            while !Task.isCancelled {
                do { try await Task.sleep(for: .milliseconds(250)) } catch { return }
                guard let self, let player = self.player else { return }
                self.currentTime = player.currentTime
                self.isPlaying = player.isPlaying
                if !player.isPlaying {
                    if let id = self.activityIdentifier { await PlaybackLiveActivity.end(id: id) }
                    self.activityIdentifier = nil
                    return
                }
            }
        }
    }
}
