import Foundation
import XCTest
@testable import CardRules

final class CardRulesTests: XCTestCase {
    private func fixture(_ first: BattleCard, other: BattleCard = BattleCard(color: .blue, value: 9)) throws -> BattleGame {
        var json = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(BattleGame())) as? [String: Any])
        json["hands"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode([[first, other], [other, other], [other, other], [other, other]]))
        json["deck"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode((0..<10).map { _ in BattleCard(color: .green, value: 3) }))
        json["discard"] = try JSONSerialization.jsonObject(with: JSONEncoder().encode([BattleCard(color: .red, value: 5)]))
        json["current"] = 0; json["direction"] = 1; json["activeColor"] = "Rojo"
        return try JSONDecoder().decode(BattleGame.self, from: JSONSerialization.data(withJSONObject: json))
    }
    func testSpecialCardsAndTurns() throws {
        for (value, expectedTurn, expectedCards) in [(10, 2, 2), (11, 3, 2), (12, 2, 4), (14, 2, 6)] {
            let card = BattleCard(color: value == 14 ? nil : .red, value: value)
            var game = try fixture(card)
            XCTAssertTrue(game.play(card, player: 0, chosenColor: .yellow))
            XCTAssertEqual(game.current, expectedTurn)
            XCTAssertEqual(game.hands[1].count, expectedCards)
            if value == 11 { XCTAssertEqual(game.direction, -1) }
        }
    }
    func testIllegalMovesAndWildColorDoNotChangeState() throws {
        let wild = BattleCard(color: nil, value: 14)
        var game = try fixture(wild, other: BattleCard(color: .red, value: 2))
        XCTAssertFalse(game.canPlay(wild, player: 0))
        XCTAssertFalse(game.play(wild, player: 0, chosenColor: .green))
        let ordinary = game.hands[0][1]
        XCTAssertFalse(game.play(ordinary, player: 1))
        XCTAssertEqual(game.current, 0)
        let regularWild = BattleCard(color: nil, value: 13)
        game = try fixture(regularWild)
        XCTAssertFalse(game.play(regularWild, player: 0))
        XCTAssertTrue(game.play(regularWild, player: 0, chosenColor: .green))
        XCTAssertEqual(game.activeColor, .green)
    }
    func testPrivateSnapshotAndPersistence() throws {
        let game = BattleGame()
        let restored = try JSONDecoder().decode(BattleGame.self, from: JSONEncoder().encode(game))
        XCTAssertEqual(restored.hands, game.hands)
        XCTAssertEqual(restored.deck, game.deck)
        let snapshot = CardRoomState(code: "1234567890", players: 4, seat: 2, version: 7, game: game)
        XCTAssertEqual(snapshot.hand, game.hands[2])
        let json = String(decoding: try JSONEncoder().encode(snapshot), as: UTF8.self)
        for card in game.hands[0] + game.hands[1] + game.hands[3] + game.deck {
            XCTAssertFalse(json.contains(card.id.uuidString))
        }
    }
    func testHundredGamesConserveDeckAndFinish() throws {
        for _ in 0..<100 {
            var game = BattleGame()
            XCTAssertTrue(game.hands.allSatisfy { $0.count == 7 })
            var turns = 0
            while game.winner == nil && turns < 10000 {
                if game.current == 0 {
                    if let card = game.hands[0].first(where: { game.canPlay($0, player: 0) }) {
                        XCTAssertTrue(game.play(card, player: 0, chosenColor: .red))
                    } else { game.drawAndPass(player: 0) }
                } else { game.botTurn() }
                let cards = game.deck + game.discard + game.hands.flatMap { $0 }
                XCTAssertEqual(cards.count, 108)
                XCTAssertEqual(Set(cards.map(\.id)).count, 108)
                turns += 1
            }
            XCTAssertNotNil(game.winner)
        }
    }
}
