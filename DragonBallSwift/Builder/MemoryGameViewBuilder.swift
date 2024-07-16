//
//  MemoryGameViewBuilder.swift
//  DragonBallSwift
//
//  Created by Josep Cerdá Penadés on 16/7/24.
//

import Foundation

final class MemoryGameViewBuilder {
    func build() -> MemoryGameView {
        let viewModel = MemoryGameViewModel()
        let view = MemoryGameView(memoryViewModel: viewModel)
        return view
    }
}
