//
//  AudioPlayerDynamicIslandLiveActivity.swift
//  AudioPlayerDynamicIsland
//
//  Created by Manuel Bermudo on 6/8/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct AudioPlayerDynamicIslandLiveActivity: Widget {
    
    @State private var activityIdentifier: String = ""
    @EnvironmentObject var songsPlayer: SongsPlayerViewModel

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AudioPlayerAttributesModel.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .center){
                        if let _ = UIImage(named: "DragonBallZDI") {
                                    Image("DragonBallZDI")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    Text("Imagen no encontrada")
                                        .foregroundColor(.red)
                                }
                    }
                    .padding(.leading, 20)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(String(context.state.currentTime.toTimeString()))
                        .padding(.trailing, 20)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.songName)
                }
                DynamicIslandExpandedRegion(.bottom){
                    VStack{
                        ProgressView(value: context.state.currentTime, total: context.state.duration)
                            .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        HStack{
                            Button(action: {
                                if context.state.isPlaying {
                                    songsPlayer.pause()
                                } else {
                                    if let url = context.state.url {
                                        songsPlayer.play(withURL: url)
                                    }
                                }
                            }, label: {
                                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                                    .frame(width: 20, height: 20)
                            })
                            .contentShape(RoundedRectangle(cornerRadius: 20))
                            Button(action: {
                                songsPlayer.stop()
                                Task{
                                    await AudioPlayerActivityUseCaseViewModel.endActivity(withActivityIdentifier: context.state.songName)
                                }
                            }, label: {
                                Image(systemName: "stop.fill")
                                    .frame(width: 20, height: 20)
                            })
                            /*Button(intent:){
                                Image(systemName: "stop.fill")
                                    .frame(width: 20, height: 20)
                            }*/
                        }
                    }
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text(context.state.songName)
            }
            .keylineTint(Color.red)
        }
    }
}

extension AudioPlayerAttributesModel {
    fileprivate static var preview: AudioPlayerAttributesModel {
        AudioPlayerAttributesModel()
    }
}

extension AudioPlayerAttributesModel.ContentState {
    fileprivate static var smiley: AudioPlayerAttributesModel.ContentState {        AudioPlayerAttributesModel.ContentState(songName: "songNameTest", isPlaying: false)
     }
     
     fileprivate static var starEyes: AudioPlayerAttributesModel.ContentState {
         AudioPlayerAttributesModel.ContentState(songName: "songNameTest", isPlaying: false)
     }
}

#Preview("Notification", as: .content, using: AudioPlayerAttributesModel.preview) {
   AudioPlayerDynamicIslandLiveActivity()
} contentStates: {
    AudioPlayerAttributesModel.ContentState.smiley
    AudioPlayerAttributesModel.ContentState.starEyes
}
