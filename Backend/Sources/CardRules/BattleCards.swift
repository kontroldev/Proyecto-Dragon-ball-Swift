import Foundation

public enum BattleColor: String, CaseIterable, Codable, Sendable {
    case red = "Rojo", yellow = "Amarillo", green = "Verde", blue = "Azul"
}

public struct BattleCard: Identifiable, Equatable, Codable, Sendable {
    public let id: UUID
    public let color: BattleColor?
    public let value: Int // 0...9, 10 salto, 11 reversa, 12 +2, 13 comodín, 14 +4
    public init(color: BattleColor?, value: Int) {
        self.id = UUID(); self.color = color; self.value = value
    }
    public var label: String {
        switch value {
        case 10: "Salto"
        case 11: "Reversa"
        case 12: "+2"
        case 13: "Color"
        case 14: "+4"
        default: String(value)
        }
    }
    public var character: String {
        ["GokuPeque", "Bulma", "Karin", "Chichi", "Chaoz", "Tenshinhan", "Krilin", "Puar", "drragon", "GokuPeque", "Chaoz", "Tenshinhan", "Krilin", "drragon", "drragon"][value]
    }
}

/// Autoridad de reglas independiente de la interfaz y del transporte online.
public struct BattleGame: Codable, Sendable {
    public private(set) var hands: [[BattleCard]] = [[], [], [], []]
    public private(set) var deck: [BattleCard] = []
    public private(set) var discard: [BattleCard] = []
    public private(set) var current = 0
    public private(set) var direction = 1
    public private(set) var activeColor = BattleColor.red
    public private(set) var winner: Int?
    public private(set) var message = "Tu turno"

    public init() {
        for color in BattleColor.allCases {
            deck.append(BattleCard(color: color, value: 0))
            for value in 1...12 {
                for _ in 0..<2 { deck.append(BattleCard(color: color, value: value)) }
            }
        }
        for _ in 0..<4 {
            deck.append(BattleCard(color: nil, value: 13))
            deck.append(BattleCard(color: nil, value: 14))
        }
        deck.shuffle()
        for player in hands.indices { for _ in 0..<7 { drawOne(player) } }
        let index = deck.firstIndex { $0.value < 10 }!
        let first = deck.remove(at: index)
        discard = [first]; activeColor = first.color!
    }

    public func canPlay(_ card: BattleCard, player: Int) -> Bool {
        guard winner == nil, hands.indices.contains(player), player == current,
              hands[player].contains(card) else { return false }
        if card.value == 14 {
            return !hands[player].contains { $0.color == activeColor }
        }
        return card.color == nil || card.color == activeColor || card.value == discard.last?.value
    }

    @discardableResult
    public mutating func play(_ card: BattleCard, player: Int, chosenColor: BattleColor? = nil) -> Bool {
        guard canPlay(card, player: player), card.color != nil || chosenColor != nil,
              let index = hands[player].firstIndex(of: card) else { return false }
        hands[player].remove(at: index); discard.append(card)
        activeColor = card.color ?? chosenColor!
        message = "\(player == 0 ? "Tú" : "Rival \(player)"): \(card.label)"
        if hands[player].isEmpty { winner = player; return true }
        if hands[player].count == 1 { message += " · ¡Una carta!" }
        if card.value == 11 { direction *= -1 }
        advance()
        if card.value == 12 || card.value == 14 {
            for _ in 0..<(card.value == 12 ? 2 : 4) { drawOne(current) }
            advance()
        } else if card.value == 10 { advance() }
        return true
    }

    /// Variante inicial: robar una carta termina el turno; no se acumulan penalizaciones.
    public mutating func drawAndPass(player: Int) {
        guard winner == nil, current == player else { return }
        drawOne(player); message = "\(player == 0 ? "Tú" : "Rival \(player)") roba una carta"
        advance()
    }

    public mutating func botTurn() {
        guard current != 0, winner == nil else { return }
        let player = current
        let playable = hands[player].filter { canPlay($0, player: player) }
        if let card = playable.sorted(by: { ($0.color != nil ? 100 : 0) + $0.value > ($1.color != nil ? 100 : 0) + $1.value }).first {
            let color = BattleColor.allCases.max { a, b in
                hands[player].filter { $0.color == a }.count < hands[player].filter { $0.color == b }.count
            }!
            play(card, player: player, chosenColor: color)
        } else { drawAndPass(player: player) }
    }

    private mutating func advance() { current = (current + direction + hands.count) % hands.count }
    private mutating func drawOne(_ player: Int) {
        if deck.isEmpty, discard.count > 1 {
            let top = discard.removeLast(); deck = discard.shuffled(); discard = [top]
        }
        if let card = deck.popLast() { hands[player].append(card) }
    }
}
