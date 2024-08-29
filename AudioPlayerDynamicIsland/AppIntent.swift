//
//  AppIntent.swift
//  AudioPlayerDynamicIsland
//
//  Created by Manuel Bermudo on 6/8/24.
//

import ActivityKit
import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

