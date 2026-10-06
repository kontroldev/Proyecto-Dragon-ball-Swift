//
//  SongsViewModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import Foundation

struct SongResource: Hashable {
    let name: String

    var url: URL? {
        Bundle.main.url(forResource: name, withExtension: "mp3")
    }
}
