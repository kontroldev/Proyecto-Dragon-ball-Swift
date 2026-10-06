import Foundation

public struct CardRoomState: Codable, Sendable {
    public let code: String
    public let players: Int
    public let seat: Int
    public let version: Int
    public let started: Bool
    public let hand: [BattleCard]
    public let counts: [Int]
    public let top: BattleCard?
    public let color: BattleColor?
    public let current: Int?
    public let winner: Int?
    public let playable: [UUID]
    public let message: String
    public init(code: String, players: Int, seat: Int, version: Int, game: BattleGame?) {
        self.code = code; self.players = players; self.seat = seat; self.version = version
        started = game != nil; hand = game?.hands[seat] ?? []
        counts = game?.hands.map(\.count) ?? []; top = game?.discard.last
        color = game?.activeColor; current = game?.current; winner = game?.winner
        playable = game?.hands[seat].filter { game!.canPlay($0, player: seat) }.map(\.id) ?? []
        message = game?.message ?? "En espera de cuatro jugadores"
    }
}

public struct CardRoomAction: Codable, Sendable {
    public let version: Int
    public let cardID: UUID?
    public let color: BattleColor?
    public let draw: Bool
    public init(version: Int, cardID: UUID? = nil, color: BattleColor? = nil, draw: Bool = false) {
        self.version = version; self.cardID = cardID; self.color = color; self.draw = draw
    }
}
