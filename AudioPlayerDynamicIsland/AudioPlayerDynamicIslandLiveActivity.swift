//
//  AudioPlayerDynamicIslandLiveActivity.swift
//  AudioPlayerDynamicIsland
//
//  Created by Manuel Bermudo on 6/8/24.
//

import ActivityKit
import SwiftUI
import WidgetKit

/// Muestra el estado publicado por la app, sin crear otro reproductor.
@main
struct AudioPlayerDynamicIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AudioPlayerAttributesModel.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                Label(context.state.songName, systemImage: "music.note")
                Text(context.state.isPlaying ? "Reproduciendo" : "En pausa")
                playbackProgress(context.state)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { Image(systemName: "music.note") }
                DynamicIslandExpandedRegion(.center) { Text(context.state.songName) }
                DynamicIslandExpandedRegion(.bottom) { playbackProgress(context.state) }
            } compactLeading: {
                Image(systemName: context.state.isPlaying ? "play.fill" : "pause.fill")
            } compactTrailing: {
                Image(systemName: "music.note")
            } minimal: {
                Image(systemName: "music.note")
            }
        }
    }

    @ViewBuilder
    private func playbackProgress(_ state: AudioPlayerAttributesModel.ContentState) -> some View {
        if state.isPlaying, let start = state.startedAt, state.duration > 0 {
            ProgressView(timerInterval: start...start.addingTimeInterval(state.duration), countsDown: false)
        } else {
            ProgressView(value: state.currentTime, total: max(1, state.duration))
        }
    }
}
