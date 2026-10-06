#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_BUILD_DIR="${TEST_BUILD_DIR:-.build/regression}"
mkdir -p "$TEST_BUILD_DIR/modules"
xcrun swiftc -disable-sandbox -swift-version 6 -parse-as-library -module-cache-path "$TEST_BUILD_DIR/modules" \
  DragonBallSwift/Service/Network/{NetworkClient,NetworkClientProtocol,NetworkMethod,URLSessionProtocol,Log}.swift \
  DragonBallSwift/Tools/ProtocolAndEnum/ProtocolAndEnum.swift \
  DragonBallSwift/Tools/ProtocolAndEnum/ApiProtocol.swift \
  DragonBallSwift/Service/AllCheracteersService.swift \
  DragonBallSwift/Model/CharacterModels/{AllCheratersModel,SingleCheranterModel,DragonBallModel,CharacterMapping,FavoriteCharacter,FavoriteCharacterStore}.swift \
  DragonBallSwift/ViewModel/CharactersViewModelApi/CharactersViewModel.swift \
  DragonBallSwift/ViewModel/FavoritesViewModel/FavoritesViewModel.swift \
  DragonBallSwift/ViewModel/MemoriGameViewModel/MemoryGameViewModel.swift \
  DragonBallSwift/Model/ModelMemoryGame/CardMemryModel.swift \
  DragonBallSwift/ViewModel/TetrisViewModel/TetrisViewModel.swift \
  DragonBallSwift/Model/TetrisModel/{GridPosition,SquereGame}.swift \
  DragonBallSwift/Model/TetrisModel/PartsModel/*.swift \
  DragonBallSwift/Tools/TetrixTools/{Protocol,ExtensionsTetrix}.swift \
  DragonBallSwift/ViewModel/AudioPlayerViewModel/SongsViewModel.swift \
  Tests/RegressionTests.swift -o "$TEST_BUILD_DIR/tests"
"$TEST_BUILD_DIR/tests"
