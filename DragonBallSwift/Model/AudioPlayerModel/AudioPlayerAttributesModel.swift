//
//  AudioPlayerAttributes.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 9/8/24.
//

import ActivityKit
import Foundation

struct AudioPlayerAttributesModel: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var songName: String
        var url: URL?
        var currentTime: TimeInterval = 0
        var duration: TimeInterval = 0
        var isPlaying: Bool
    }
}
