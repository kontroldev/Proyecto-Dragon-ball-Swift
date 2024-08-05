//
//  SongsModel.swift
//  DragonBallSwift
//
//  Created by Manuel Bermudo on 4/8/24.
//

import AVFoundation
import Foundation
import SwiftUI

struct SongsViewModel: Hashable {
    let name: String
    
    //Para obtener la canción
    func getURL() -> URL {
        return URL(string: Bundle.main.path(forResource: name, ofType: "mp3")!)!
    }
}
