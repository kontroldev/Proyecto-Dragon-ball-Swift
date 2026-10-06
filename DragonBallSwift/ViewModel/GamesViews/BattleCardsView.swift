import SwiftUI

private let battleRules = "Gana quien se quede sin cartas. Juega el mismo color o valor. Salto omite un rival; Reversa cambia el sentido; +2 y +4 hacen robar y perder turno. +4 solo si no tienes el color activo. Robar termina tu turno. No se acumulan penalizaciones. El aviso de una carta es automático."

private func battleTint(_ color: BattleColor?) -> Color {
    switch color {
    case .red: Color(red: 0.9, green: 0.12, blue: 0.12)
    case .yellow: Color(red: 0.98, green: 0.76, blue: 0.05)
    case .green: Color(red: 0.1, green: 0.64, blue: 0.25)
    case .blue: Color(red: 0.05, green: 0.4, blue: 0.85)
    case nil: Color(white: 0.1)
    }
}

/// Logo del reverso de las cartas; lo elige el usuario y se guarda entre partidas.
enum CardLogo: String, CaseIterable, Identifiable {
    case dragonBall = "DBLogo", z = "ZLogo", dbSuper = "SuperLogo", gt = "GTLogo"
    var id: String { rawValue }
    var title: String {
        switch self {
        case .dragonBall: "Dragon Ball"
        case .z: "Z"
        case .dbSuper: "Super"
        case .gt: "GT"
        }
    }
}

/// Personajes que aparecen en las cartas y que se pueden elegir como avatar.
private let battleCharacters: [(image: String, name: String)] = [
    ("GokuPeque", "Goku"), ("Bulma", "Bulma"), ("Krilin", "Krilin"), ("Tenshinhan", "Ten Shin Han"),
    ("Chaoz", "Chaoz"), ("Chichi", "Chi-Chi"), ("Karin", "Karin"), ("Puar", "Puar"), ("drragon", "Shenron")
]
private let defaultAvatars = ["GokuPeque", "Krilin", "Bulma", "Tenshinhan"]
private let avatarColors: [Color] = [.orange, .blue, .pink, .green]

private func characterName(_ image: String) -> String {
    battleCharacters.first { $0.image == image }?.name ?? image
}

/// Lugares de la mesa entre los que vuelan las cartas.
private enum TableSpot: Hashable {
    case deck, center, seat(Int)
}

/// Carta en movimiento: mientras vuela, la mesa oculta la carta real en su destino.
private struct CardFlight: Identifiable {
    let id = UUID()
    let card: BattleCard
    let from: TableSpot
    let to: TableSpot
    var delay: Double = 0
    var faceUp = false
    static let duration = 0.45
}

/// Carta opaca al estilo clásico: borde blanco, fondo de color, óvalo blanco inclinado y valor en las esquinas.
private struct BattleCardFace: View {
    let card: BattleCard?
    var width: CGFloat = 78
    /// Permite mostrar un reverso concreto (p. ej. en el selector) sin cambiar la preferencia guardada.
    var logoOverride: CardLogo?
    @AppStorage("battleCardLogo") private var logo = CardLogo.dragonBall

    private var height: CGFloat { width * 1.45 }
    private var inset: CGFloat { width * 0.07 }
    private var innerRadius: CGFloat { width * 0.08 }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: width * 0.12).fill(.white)
            Group {
                if let card { face(card) } else { back }
            }
            .frame(width: width - inset * 2, height: height - inset * 2)
            .clipShape(RoundedRectangle(cornerRadius: innerRadius))
        }
        .frame(width: width, height: height)
        .compositingGroup()
        .shadow(color: .black.opacity(0.45), radius: width * 0.05, x: 0, y: width * 0.04)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(card.map { "\($0.label), \($0.color?.rawValue ?? "comodín")" } ?? "Carta oculta")
    }

    private func face(_ card: BattleCard) -> some View {
        ZStack {
            battleTint(card.color)
            Ellipse()
                .fill(card.color == nil
                      ? AnyShapeStyle(AngularGradient(colors: [.red, .yellow, .green, .blue, .red], center: .center))
                      : AnyShapeStyle(Color.white))
                .frame(width: width * 0.74, height: width * 1.15)
                .rotationEffect(.degrees(28))
            Image(card.character)
                .resizable().scaledToFit()
                .frame(width: width * 0.58, height: width * 0.8)
            VStack {
                HStack { corner(card); Spacer() }
                Spacer()
                HStack { Spacer(); corner(card).rotationEffect(.degrees(180)) }
            }
            .padding(width * 0.05)
        }
    }

    private func corner(_ card: BattleCard) -> some View {
        Group {
            switch card.value {
            case 10: Image(systemName: "nosign")
            case 11: Image(systemName: "arrow.triangle.2.circlepath")
            case 13: Image(systemName: "paintpalette.fill")
            default: Text(card.label)
            }
        }
        .font(.system(size: width * 0.22, weight: .black, design: .rounded))
        .foregroundStyle(.white)
        .shadow(color: .black, radius: 0, x: width * 0.012, y: width * 0.015)
    }

    /// Reverso: fondo negro, óvalo rojo inclinado y el logo de la serie elegida.
    private var back: some View {
        ZStack {
            Color(white: 0.06)
            Ellipse()
                .fill(Color(red: 0.88, green: 0.1, blue: 0.1))
                .frame(width: width * 0.72, height: width * 1.12)
                .rotationEffect(.degrees(28))
            Image((logoOverride ?? logo).rawValue)
                .resizable().scaledToFit()
                .frame(width: width * 1.05)
                .shadow(color: .black.opacity(0.6), radius: 0, x: width * 0.01, y: width * 0.01)
                .rotationEffect(.degrees(-28))
        }
    }
}

// MARK: - Escenario

/// Fondo de la sala: tonos neón morados con altavoces decorativos, al estilo de una sala de juegos.
private struct BattleArena: View {
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width, h = geometry.size.height
            ZStack {
                LinearGradient(colors: [Color(red: 0.16, green: 0.08, blue: 0.4), Color(red: 0.45, green: 0.16, blue: 0.55), Color(red: 0.24, green: 0.07, blue: 0.36)],
                               startPoint: .top, endPoint: .bottom)
                Circle().fill(.pink.opacity(0.4)).frame(width: w * 0.6).blur(radius: 80).position(x: w * 0.15, y: h * 0.15)
                Circle().fill(.orange.opacity(0.3)).frame(width: w * 0.6).blur(radius: 90).position(x: w * 0.85, y: h * 0.12)
                Circle().fill(.cyan.opacity(0.3)).frame(width: w * 0.5).blur(radius: 80).position(x: w * 0.9, y: h * 0.85)
                Circle().fill(.blue.opacity(0.35)).frame(width: w * 0.5).blur(radius: 80).position(x: w * 0.05, y: h * 0.8)
                speaker.frame(width: w * 0.22, height: w * 0.22).position(x: w * 0.04, y: h * 0.14)
                speaker.frame(width: w * 0.22, height: w * 0.22).position(x: w * 0.96, y: h * 0.14)
                ForEach(0..<14, id: \.self) { index in
                    // Confeti decorativo con posiciones fijas para que no cambie entre renders.
                    RoundedRectangle(cornerRadius: 1)
                        .fill([Color.cyan, .pink, .yellow, .white][index % 4].opacity(0.6))
                        .frame(width: 5, height: 12)
                        .rotationEffect(.degrees(Double(index) * 37))
                        .position(x: w * CGFloat((index * 37) % 100) / 100, y: h * CGFloat((index * 53) % 45) / 100)
                }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private var speaker: some View {
        ZStack {
            Circle().fill(Color(red: 0.25, green: 0.1, blue: 0.4))
            Circle().stroke(.purple, lineWidth: 10).padding(14)
            Circle().fill(Color(red: 0.4, green: 0.15, blue: 0.55)).padding(34)
            Circle().fill(.pink.opacity(0.5)).padding(60)
        }
        .opacity(0.7)
    }
}

/// Arco del indicador de sentido de juego.
private struct DirectionArc: SwiftUI.Shape {
    let start: Angle
    let end: Angle
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) / 2,
                    startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}

/// Punta de flecha situada al final del arco, orientada según la tangente (sentido horario en pantalla).
private struct DirectionHead: SwiftUI.Shape {
    let angle: Angle
    let size: CGFloat
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let a = angle.radians
        let normal = CGPoint(x: cos(a), y: sin(a))
        let tangent = CGPoint(x: -sin(a), y: cos(a))
        let base = CGPoint(x: rect.midX + radius * normal.x, y: rect.midY + radius * normal.y)
        var path = Path()
        path.move(to: CGPoint(x: base.x + tangent.x * size, y: base.y + tangent.y * size))
        path.addLine(to: CGPoint(x: base.x + normal.x * size * 0.75, y: base.y + normal.y * size * 0.75))
        path.addLine(to: CGPoint(x: base.x - normal.x * size * 0.75, y: base.y - normal.y * size * 0.75))
        path.closeSubpath()
        return path
    }
}

/// Plataforma circular central con rejilla y flechas que indican el sentido del turno.
private struct BattlePlatform: View {
    let direction: Int
    /// Color activo: las flechas lo muestran, como en la mesa de referencia.
    var tint = Color(red: 1, green: 0.88, blue: 0)
    var body: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(red: 0.98, green: 0.72, blue: 0.62), Color(red: 0.78, green: 0.42, blue: 0.45)], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black.opacity(0.45), radius: 18, y: 10)
                Circle().stroke(Color(red: 1, green: 0.86, blue: 0.76).opacity(0.7), lineWidth: 3).padding(side * 0.03)
                Circle()
                    .fill(RadialGradient(colors: [Color(red: 1, green: 0.84, blue: 0.4), Color(red: 0.96, green: 0.6, blue: 0.25)], center: .center, startRadius: 5, endRadius: side * 0.45))
                    .overlay {
                        Canvas { context, size in
                            var grid = Path()
                            stride(from: 0, through: size.width, by: 12).forEach { grid.move(to: CGPoint(x: $0, y: 0)); grid.addLine(to: CGPoint(x: $0, y: size.height)) }
                            stride(from: 0, through: size.height, by: 12).forEach { grid.move(to: CGPoint(x: 0, y: $0)); grid.addLine(to: CGPoint(x: size.width, y: $0)) }
                            context.stroke(grid, with: .color(.brown.opacity(0.18)), lineWidth: 1)
                        }.clipShape(Circle())
                    }
                    .padding(side * 0.1)
                Group {
                    arrow(from: .degrees(200), to: .degrees(325), side: side)
                    arrow(from: .degrees(20), to: .degrees(145), side: side)
                }
                .padding(side * 0.15)
                .scaleEffect(x: direction < 0 ? -1 : 1)
                .animation(.spring, value: direction)
                .animation(.easeInOut, value: tint)
            }
            .frame(width: side, height: side)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .accessibilityHidden(true)
    }

    private func arrow(from start: Angle, to end: Angle, side: CGFloat) -> some View {
        ZStack {
            DirectionArc(start: start, end: end)
                .stroke(tint, style: StrokeStyle(lineWidth: side * 0.06, lineCap: .butt))
            DirectionHead(angle: end, size: side * 0.08).fill(tint)
        }
        .shadow(color: .black.opacity(0.35), radius: 2, y: 3)
    }
}

/// Destello al jugar una carta: un flash de luz y triángulos del color activo que salen disparados.
private struct PlayBurst: View {
    let color: Color
    let size: CGFloat
    @State private var expanded = false

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [.white, .yellow.opacity(0.7), .clear], center: .center, startRadius: 0, endRadius: size * 0.5))
                .frame(width: size, height: size)
                .scaleEffect(expanded ? 1.3 : 0.2)
            ForEach(0..<10, id: \.self) { index in
                let angle = Double(index) / 10 * 2 * .pi
                Triangle()
                    .fill(color.mix(with: .white, by: index.isMultiple(of: 2) ? 0 : 0.3))
                    .frame(width: size * 0.09, height: size * 0.09)
                    .rotationEffect(.degrees(Double(index) * 47))
                    .offset(x: expanded ? cos(angle) * size * 0.55 : 0, y: expanded ? sin(angle) * size * 0.55 : 0)
            }
        }
        .opacity(expanded ? 0 : 1)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear { withAnimation(.easeOut(duration: 0.6)) { expanded = true } }
    }
}

private struct Triangle: SwiftUI.Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// Carta que vuela de un punto de la mesa a otro, cambiando de tamaño y giro por el camino.
private struct FlyingCard: View {
    let flight: CardFlight
    let from: (point: CGPoint, width: CGFloat, angle: Double)
    let to: (point: CGPoint, width: CGFloat, angle: Double)
    @State private var arrived = false

    var body: some View {
        BattleCardFace(card: flight.faceUp ? flight.card : nil, width: from.width)
            .scaleEffect(arrived ? to.width / max(1, from.width) : 1)
            .rotationEffect(.degrees(arrived ? to.angle : from.angle))
            .position(arrived ? to.point : from.point)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.easeOut(duration: CardFlight.duration).delay(flight.delay)) { arrived = true }
            }
    }
}

/// Logo de la serie elegida grabado sobre la plataforma antes de empezar.
private struct CenterLogo: View {
    let width: CGFloat
    @AppStorage("battleCardLogo") private var logo = CardLogo.dragonBall

    var body: some View {
        Image(logo.rawValue)
            .resizable().scaledToFit()
            .frame(width: width)
            .shadow(color: .black.opacity(0.4), radius: 4, y: 3)
            .accessibilityHidden(true)
    }
}

// MARK: - Mesa

private struct BattleTable: View {
    let hand: [BattleCard]
    let counts: [Int]
    let seat: Int
    let current: Int
    let winner: Int?
    let top: BattleCard?
    let activeColor: BattleColor
    let message: String
    let playable: [UUID]
    let online: Bool
    let busy: Bool
    var direction = 1
    /// Últimas cartas del descarte (la última es la de arriba); si está vacío se usa `top`.
    var pile: [BattleCard] = []
    var flights: [CardFlight] = []
    var avatars = defaultAvatars
    var names: [String] = []
    /// Tiempo restante de la partida ya formateado (mm:ss).
    var clock: String?
    let play: (BattleCard) -> Void
    let draw: () -> Void
    let restart: () -> Void

    private let nameRed = Color(red: 0.82, green: 0.25, blue: 0.08)

    private var canDraw: Bool { !busy && current == seat && winner == nil }

    // Mientras una carta vuela, se oculta en su destino para que no aparezca dos veces.
    private var flyingIDs: Set<UUID> { Set(flights.map(\.card.id)) }
    private var visibleHand: [BattleCard] { hand.filter { !flyingIDs.contains($0.id) } }
    private var visiblePile: [BattleCard] {
        (pile.isEmpty ? [top].compactMap { $0 } : pile).filter { !flyingIDs.contains($0.id) }
    }
    private func visibleCount(_ player: Int) -> Int {
        max(0, counts[player] - flights.filter { $0.to == .seat(player) }.count)
    }

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            let landscape = w > h
            // Escala los elementos en pantallas grandes (iPad) partiendo del tamaño de un iPhone.
            let scale = min(2, max(1, min(w, h) / 420))
            let badge = (landscape ? 44 : 58) * scale
            let button = (landscape ? 58 : 72) * scale
            // Mano: cartas grandes y rectas que se solapan dejando ver la mitad izquierda de cada una.
            let overlap: CGFloat = 0.5
            let maxHand = (landscape ? 64 : 82) * scale
            // Se limita a 0 para evitar dimensiones negativas cuando el GeometryReader aún mide poco (p. ej. ancho 0).
            let handSpace = max(0, w - badge * 2.6 - button * 1.3)
            let handWidth = min(maxHand, handSpace / (1 + CGFloat(max(0, hand.count - 1)) * overlap))
            let handHeight = handWidth * 1.45
            let tableTop = badge * 1.35
            let tableBottom = h - handHeight * 0.8 - 24
            let diameter = max(120, min(w * 0.8, tableBottom - tableTop))
            let center = CGPoint(x: w / 2, y: (tableTop + tableBottom) / 2)
            let fanCard = badge * 0.55
            let sideY = center.y - diameter * 0.2
            let leftX = badge * 0.75 + 8
            let rightX = w - badge * 0.75 - 8
            let topPlayer = (seat + 2) % 4

            let centerCard = diameter * 0.16
            let deckPoint = CGPoint(x: center.x - diameter * 0.3, y: center.y - diameter * 0.3)
            let topFanPoint = CGPoint(x: center.x + badge * 0.95, y: badge * 0.55)
            let leftFanPoint = CGPoint(x: leftX + badge * 0.45, y: sideY + badge * 1.45)
            let rightFanPoint = CGPoint(x: rightX - badge * 0.45, y: sideY + badge * 1.45)
            let handPoint = CGPoint(x: center.x, y: h - handHeight * 0.45)

            // Punto, tamaño y giro de cada lugar de la mesa, para animar las cartas que vuelan.
            let spot: (TableSpot) -> (point: CGPoint, width: CGFloat, angle: Double) = { place in
                switch place {
                case .deck: (deckPoint, diameter * 0.13, -35)
                case .center: (CGPoint(x: center.x, y: center.y - diameter * 0.03), centerCard, -8)
                case .seat(let player):
                    switch (player - seat + 4) % 4 {
                    case 0: (handPoint, handWidth, 0)
                    case 1: (leftFanPoint, fanCard, 40)
                    case 2: (topFanPoint, fanCard, 0)
                    default: (rightFanPoint, fanCard, -40)
                    }
                }
            }

            ZStack {
                BattleArena()

                BattlePlatform(direction: direction, tint: top == nil ? Color(red: 1, green: 0.88, blue: 0) : battleTint(activeColor))
                    .frame(width: diameter, height: diameter)
                    .position(center)
                    .accessibilityElement()
                    .accessibilityLabel("Color activo: \(activeColor.rawValue)")

                deckStack(width: diameter * 0.13)
                    .position(deckPoint)

                // Antes de que salga la primera carta, el centro muestra el logo elegido, como el "UNO" del vídeo.
                if visiblePile.isEmpty {
                    CenterLogo(width: diameter * 0.55)
                        .position(center)
                        .transition(.scale.combined(with: .opacity))
                }

                // Pila de descartes: las anteriores asoman giradas bajo la de arriba.
                ForEach(Array(visiblePile.suffix(3).enumerated()), id: \.element.id) { index, card in
                    BattleCardFace(card: card, width: centerCard)
                        .rotationEffect(.degrees(index == visiblePile.suffix(3).count - 1 ? -8 : pileAngle(card)))
                        .transition(.scale(scale: 1.4).combined(with: .opacity))
                        .position(x: center.x, y: center.y - diameter * 0.03)
                }

                if let last = visiblePile.last {
                    PlayBurst(color: battleTint(activeColor), size: diameter * 0.7)
                        .id(last.id)
                        .position(center)
                }

                // Rival de arriba: avatar y abanico de cartas a su derecha.
                seatBadge(topPlayer, size: badge)
                    .position(x: center.x - badge * 0.9, y: badge * 0.7)
                horizontalFan(visibleCount(topPlayer), width: fanCard)
                    .position(topFanPoint)

                // Rivales laterales: avatar en el borde y cartas en diagonal hacia la mesa.
                diagonalFan(visibleCount((seat + 1) % 4), width: fanCard, left: true)
                    .position(leftFanPoint)
                seatBadge((seat + 1) % 4, size: badge)
                    .position(x: leftX, y: sideY)
                diagonalFan(visibleCount((seat + 3) % 4), width: fanCard, left: false)
                    .position(rightFanPoint)
                seatBadge((seat + 3) % 4, size: badge)
                    .position(x: rightX, y: sideY)

                if let clock {
                    Label(clock, systemImage: "alarm.fill")
                        .font(.system(size: 15 * scale, weight: .heavy, design: .rounded).monospacedDigit())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(.black.opacity(0.45), in: Capsule())
                        .overlay(Capsule().stroke(.white.opacity(0.6), lineWidth: 1.5))
                        .position(x: leftX + 10, y: badge * 0.35)
                        .accessibilityLabel("Tiempo restante \(clock)")
                }

                Text(message)
                    .font(.caption.bold()).foregroundStyle(.white).lineLimit(2).multilineTextAlignment(.center)
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(.black.opacity(0.4), in: Capsule())
                    .frame(maxWidth: diameter * 0.8)
                    .position(x: center.x, y: center.y + diameter * 0.27)

                // Mi zona: avatar abajo a la izquierda, mano en el centro y botón de robar a la derecha.
                playerBadge(size: badge)
                    .position(x: leftX + badge * 0.15, y: h - badge * 0.75)

                Group {
                    if hand.count <= 12 {
                        handCards(width: handWidth, overlap: overlap)
                    } else {
                        ScrollView(.horizontal) { handCards(width: handWidth, overlap: overlap) }
                            .frame(width: handSpace)
                    }
                }
                .position(handPoint)

                drawButton(size: button)
                    .position(x: w - button * 0.7, y: h - button * 0.7)

                ForEach(flights) { flight in
                    FlyingCard(flight: flight, from: spot(flight.from), to: spot(flight.to))
                }

                if let winner { winnerOverlay(winner).position(center) }
            }
        }
    }

    // MARK: Centro

    /// Mazo tumbado sobre la mesa con grosor; al tocarlo robas.
    private func deckStack(width: CGFloat) -> some View {
        Button { if canDraw { draw() } } label: {
            ZStack {
                ForEach(0..<6, id: \.self) { index in
                    RoundedRectangle(cornerRadius: width * 0.12)
                        .fill(index.isMultiple(of: 2) ? Color.white : Color(white: 0.85))
                        .frame(width: width, height: width * 1.45)
                        .offset(x: CGFloat(index) * width * 0.02, y: CGFloat(index) * width * 0.035)
                }
                BattleCardFace(card: nil, width: width)
            }
            .rotationEffect(.degrees(-35))
            .rotation3DEffect(.degrees(40), axis: (x: 1, y: 0, z: 0))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Robar una carta y pasar turno")
    }

    // MARK: Asientos

    private func displayName(_ player: Int) -> String {
        if player == seat { return "Tú" }
        if online { return "Jugador \(player + 1)" }
        return names.indices.contains(player) ? names[player] : characterName(avatars[player])
    }

    /// Giro fijo por carta para que las de debajo de la pila no "bailen" entre renders.
    private func pileAngle(_ card: BattleCard) -> Double {
        let seed = card.id.uuid.0 ^ card.id.uuid.5
        return Double(Int(seed) % 40) - 20
    }

    private func seatBadge(_ player: Int, size: CGFloat, nameColor: Color? = nil) -> some View {
        let isCurrent = current == player && winner == nil
        return VStack(spacing: size * 0.1) {
            Image(avatars[player])
                .resizable().scaledToFit().padding(size * 0.08)
                .frame(width: size, height: size)
                .background(avatarColors[player].gradient, in: RoundedRectangle(cornerRadius: size * 0.2))
                .overlay(RoundedRectangle(cornerRadius: size * 0.2).stroke(.white, lineWidth: size * 0.07))
                .shadow(color: isCurrent ? .yellow : .black.opacity(0.4), radius: isCurrent ? size * 0.2 : 4)
                .scaleEffect(isCurrent ? 1.08 : 1)
            Text(displayName(player))
                .font(.system(size: size * 0.24, weight: .bold, design: .rounded))
                .foregroundStyle(.white).lineLimit(1).minimumScaleFactor(0.6)
                .frame(width: size * 1.45, height: size * 0.36)
                .background(nameColor ?? nameRed, in: RoundedRectangle(cornerRadius: size * 0.12))
        }
        .animation(.spring, value: isCurrent)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(displayName(player)), \(counts[player]) cartas\(isCurrent ? ", su turno" : "")")
    }

    private func playerBadge(size: CGFloat) -> some View {
        seatBadge(seat, size: size, nameColor: Color(red: 0.1, green: 0.55, blue: 0.95))
            .overlay(alignment: .top) {
                if hand.count == 1 && winner == nil {
                    Text("¡UNA CARTA!")
                        .font(.caption2.bold()).foregroundStyle(.white)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(.orange, in: Capsule())
                        .offset(y: -22)
                }
            }
    }

    private func horizontalFan(_ count: Int, width: CGFloat) -> some View {
        let shown = min(count, 10)
        let mid = Double(shown - 1) / 2
        return HStack(spacing: -width * 0.72) {
            ForEach(0..<shown, id: \.self) { index in
                BattleCardFace(card: nil, width: width)
                    .rotationEffect(.degrees((Double(index) - mid) * 3))
                    .offset(y: abs(Double(index) - mid) * 1.2)
            }
        }
        .accessibilityHidden(true)
    }

    /// Abanico en diagonal: las cartas suben desde el borde hacia el centro de la mesa.
    private func diagonalFan(_ count: Int, width: CGFloat, left: Bool) -> some View {
        let shown = min(count, 10)
        let mid = Double(shown - 1) / 2
        let step = width * 0.42
        let angle = 50.0 * .pi / 180
        return ZStack {
            ForEach(0..<shown, id: \.self) { index in
                let t = CGFloat(Double(index) - mid)
                BattleCardFace(card: nil, width: width)
                    .rotationEffect(.degrees(left ? 40 : -40))
                    .offset(x: t * step * cos(angle) * (left ? 1 : -1), y: -t * step * sin(angle))
            }
        }
        .frame(width: width * 3, height: width * 3)
        .accessibilityHidden(true)
    }

    // MARK: Mano y acciones

    private func handCards(width: CGFloat, overlap: CGFloat) -> some View {
        HStack(spacing: -width * (1 - overlap)) {
            ForEach(Array(visibleHand.enumerated()), id: \.element.id) { index, card in
                let isPlayable = playable.contains(card.id) && !busy
                // Sin `.disabled`: SwiftUI atenúa los botones desactivados y las cartas parecerían transparentes.
                Button { if isPlayable { play(card) } } label: { BattleCardFace(card: card, width: width) }
                    .buttonStyle(.plain)
                    .offset(y: isPlayable && current == seat && winner == nil ? -width * 0.22 : 0)
                    .zIndex(Double(index))
                    .accessibilityHint(isPlayable ? "Jugar carta" : "No se puede jugar ahora")
            }
        }
        .padding(.top, width * 0.25)
        .animation(.spring, value: visibleHand.map(\.id))
        .animation(.spring, value: current)
    }

    /// Botón rojo redondo sobre su base, como el pulsador de la imagen de referencia.
    private func drawButton(size: CGFloat) -> some View {
        Button { if canDraw { draw() } } label: {
            ZStack {
                Ellipse()
                    .fill(LinearGradient(colors: [Color(red: 0.55, green: 0.65, blue: 0.95), Color(red: 0.25, green: 0.3, blue: 0.6)], startPoint: .top, endPoint: .bottom))
                    .frame(width: size * 1.1, height: size * 0.75)
                    .offset(y: size * 0.32)
                Ellipse()
                    .fill(Color(red: 0.6, green: 0.02, blue: 0.08))
                    .frame(width: size, height: size * 0.9)
                    .offset(y: size * 0.1)
                Ellipse()
                    .fill(RadialGradient(colors: [Color(red: 1, green: 0.4, blue: 0.4), Color(red: 0.85, green: 0.05, blue: 0.1)], center: .init(x: 0.35, y: 0.3), startRadius: 2, endRadius: size * 0.7))
                    .frame(width: size, height: size * 0.9)
                Text("ROBAR")
                    .font(.custom("SaiyanSans", size: size * 0.34))
                    .foregroundStyle(.yellow)
                    .shadow(color: .black, radius: 0, x: 1.5, y: 1.5)
                    .shadow(color: .black, radius: 0, x: -1, y: -1)
                    .rotationEffect(.degrees(-12))
            }
            .frame(width: size * 1.1, height: size * 1.2)
            .offset(y: canDraw ? 0 : size * 0.04)
        }
        .buttonStyle(.plain)
        .saturation(canDraw ? 1 : 0.5)
        .accessibilityLabel("Robar una carta y pasar turno")
    }

    private func winnerOverlay(_ winner: Int) -> some View {
        VStack {
            Text(winner == seat ? "¡HAS GANADO!" : "FIN DE PARTIDA").font(.custom("SaiyanSans", size: 50))
                .foregroundStyle(.yellow).padding(5)
                .shadow(color: .red, radius: 10)
            if winner != seat {
                Text("Gana \(displayName(winner))").font(.headline).foregroundStyle(.white)
            }
            if !online {
                Button("Volver a jugar", action: restart)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.red))
                    .shadow(color: .orange, radius: 20)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 2)
                .background(Color("CardColor").opacity(0.70))
                .clipShape(.rect(cornerRadius: 8))
        )
        .shadow(color: .blue, radius: 10)
    }
}

// MARK: - Contra la máquina

private enum BattlePhase: Equatable {
    case setup, countdown(Int), playing
}

/// Pantalla previa: elegir el reverso de las cartas y qué personaje es cada jugador.
private struct BattleSetupView: View {
    @Binding var avatars: [String]
    let start: () -> Void
    @AppStorage("battleCardLogo") private var logo = CardLogo.dragonBall
    private let seatTitles = ["Tú", "Rival de la izquierda", "Rival de enfrente", "Rival de la derecha"]

    var body: some View {
        ZStack {
            BattleArena()
            ScrollView {
                VStack(spacing: 18) {
                    Text("Cartas Dragon Ball")
                        .font(.custom("SaiyanSans", size: 46))
                        .foregroundStyle(.yellow)
                        .shadow(color: .black, radius: 0, x: 2, y: 2)

                    section("Reverso de las cartas") {
                        HStack(spacing: 10) {
                            ForEach(CardLogo.allCases) { option in
                                logoButton(option)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    ForEach(0..<4, id: \.self) { seat in
                        section(seatTitles[seat]) { characterPicker(seat) }
                    }

                    Button(action: start) {
                        Text("¡A jugar!")
                            .font(.custom("SaiyanSans", size: 34))
                            .foregroundStyle(.yellow)
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                            .padding(.horizontal, 40).padding(.vertical, 10)
                            .background(Color(red: 0.85, green: 0.05, blue: 0.1).gradient, in: Capsule())
                            .overlay(Capsule().stroke(.white, lineWidth: 3))
                            .shadow(color: .orange, radius: 12)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                }
                .padding()
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(.white)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
    }

    private func logoButton(_ option: CardLogo) -> some View {
        let selected = logo == option
        return Button { withAnimation(.spring) { logo = option } } label: {
            VStack(spacing: 6) {
                BattleCardFace(card: nil, width: 60, logoOverride: option)
                Text(option.title).font(.caption.bold()).foregroundStyle(.white).lineLimit(1).minimumScaleFactor(0.7)
            }
            .padding(6)
            .background(.white.opacity(selected ? 0.25 : 0), in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(selected ? .yellow : .clear, lineWidth: 3))
            .scaleEffect(selected ? 1.05 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Reverso \(option.title)")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func characterPicker(_ seat: Int) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(battleCharacters, id: \.image) { character in
                    let selected = avatars[seat] == character.image
                    Button { withAnimation(.spring) { avatars[seat] = character.image } } label: {
                        VStack(spacing: 4) {
                            Image(character.image)
                                .resizable().scaledToFit().padding(5)
                                .frame(width: 56, height: 56)
                                .background(avatarColors[seat].gradient, in: RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(selected ? .yellow : .white.opacity(0.5), lineWidth: selected ? 4 : 2))
                                .scaleEffect(selected ? 1.08 : 1)
                            Text(character.name).font(.caption2.bold()).foregroundStyle(.white).lineLimit(1).minimumScaleFactor(0.7)
                        }
                        .frame(width: 70)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(character.name)
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }
            .padding(.vertical, 6)
        }
    }
}

struct BattleCardsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var game = BattleGame()
    @State private var phase = BattlePhase.setup
    @State private var flights: [CardFlight] = []
    @State private var remaining = BattleCardsView.matchSeconds
    @State private var timeWinner: Int?
    @State private var pendingCard: BattleCard?
    @State private var showsRules = false
    @AppStorage("battleAvatars") private var storedAvatars = defaultAvatars.joined(separator: ",")

    private static let matchSeconds = 300

    private var avatars: [String] {
        let list = storedAvatars.split(separator: ",").map(String.init)
        return list.count == 4 ? list : defaultAvatars
    }
    private var names: [String] { avatars.map(characterName) }
    /// Gana quien se queda sin cartas o, si se acaba el tiempo, quien tenga menos.
    private var winner: Int? { game.winner ?? timeWinner }
    private var isAnimating: Bool { phase != .playing || !flights.isEmpty }
    /// Sustituye "Rival N" de las reglas por el nombre del personaje elegido.
    private var message: String {
        (1..<4).reduce(game.message) { $0.replacingOccurrences(of: "Rival \($1)", with: names[$1]) }
    }
    private var clock: String { String(format: "%02d:%02d", remaining / 60, remaining % 60) }

    var body: some View {
        NavigationStack {
            Group {
                if phase == .setup {
                    BattleSetupView(avatars: Binding(get: { avatars }, set: { storedAvatars = $0.joined(separator: ",") }),
                                    start: startMatch)
                } else {
                    table.overlay { countdownOverlay }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()

                            Text("Volver")
                                .font(.callout)
                        }
                    }
                }

                ToolbarItem(placement: .automatic) {
                    Button {
                        showsRules = true
                    } label: {
                        Label("Reglas", systemImage: "book.fill")
                    }
                }

                if phase != .setup {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            flights = []
                            phase = .setup
                        } label: {
                            Label("Cartas y personajes", systemImage: "person.2.crop.square.stack.fill")
                        }
                    }

                    // En la barra superior para que no tape la mano del jugador.
                    ToolbarItem(placement: .automatic) {
                        Button(action: startMatch) {
                            Label("Reiniciar", systemImage: "arrow.counterclockwise.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .confirmationDialog("Elige el color", isPresented: Binding(get: { pendingCard != nil }, set: { if !$0 { pendingCard = nil } }), titleVisibility: .visible) {
                ForEach(BattleColor.allCases, id: \.self) { color in
                    Button(color.rawValue) {
                        if let card = pendingCard { perform { $0.play(card, player: 0, chosenColor: color) } }
                        pendingCard = nil
                    }
                }
            }
            .alert("Reglas", isPresented: $showsRules) { Button("Entendido", role: .cancel) {} } message: { Text(battleRules) }
            // Cuenta atrás 5…1 antes de repartir.
            .task(id: phase) {
                guard case .countdown(let number) = phase else { return }
                do { try await Task.sleep(for: .seconds(1)) } catch { return }
                if number > 1 {
                    withAnimation(.spring) { phase = .countdown(number - 1) }
                } else {
                    phase = .playing
                    deal()
                }
            }
            // Reloj de la partida.
            .task(id: phase == .playing && winner == nil) {
                guard phase == .playing, winner == nil else { return }
                while remaining > 0 {
                    do { try await Task.sleep(for: .seconds(1)) } catch { return }
                    remaining -= 1
                }
                let counts = game.hands.map(\.count)
                withAnimation(.spring) { timeWinner = counts.indices.min { counts[$0] < counts[$1] } }
            }
            // Turnos de la máquina.
            .task(id: "\(game.current)-\(phase == .playing)-\(winner == nil)") {
                while phase == .playing && game.current != 0 && winner == nil {
                    do { try await Task.sleep(for: .milliseconds(900)) } catch { return }
                    guard !Task.isCancelled else { return }
                    // Espera a que terminen de volar las cartas (p. ej. el reparto) antes de jugar.
                    guard flights.isEmpty else { continue }
                    perform { $0.botTurn() }
                }
            }
        }
    }

    private var table: some View {
        let dealing = phase != .playing
        return BattleTable(hand: dealing ? [] : game.hands[0], counts: dealing ? [0, 0, 0, 0] : game.hands.map(\.count), seat: 0,
                           current: game.current, winner: winner, top: dealing ? nil : game.discard.last,
                           activeColor: game.activeColor, message: dealing ? "¡Prepárate!" : message,
                           playable: winner == nil ? game.hands[0].filter { game.canPlay($0, player: 0) }.map(\.id) : [],
                           online: false, busy: isAnimating, direction: game.direction,
                           pile: dealing ? [] : Array(game.discard.suffix(3)), flights: flights,
                           avatars: avatars, names: names, clock: clock,
                           play: { card in
                               if card.color == nil { pendingCard = card } else { perform { $0.play(card, player: 0) } }
                           }, draw: { perform { $0.drawAndPass(player: 0) } }, restart: startMatch)
    }

    @ViewBuilder private var countdownOverlay: some View {
        if case .countdown(let number) = phase {
            Text("\(number)")
                .font(.custom("SaiyanSans", size: 180))
                .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                .shadow(color: .black, radius: 0, x: 5, y: 5)
                .shadow(color: .orange, radius: 24)
                .id(number)
                .transition(.asymmetric(insertion: .scale(scale: 2.2).combined(with: .opacity),
                                        removal: .scale(scale: 0.4).combined(with: .opacity)))
                .accessibilityLabel("La partida empieza en \(number)")
        }
    }

    private func startMatch() {
        game = BattleGame()
        flights = []
        timeWinner = nil
        pendingCard = nil
        remaining = Self.matchSeconds
        withAnimation(.spring) { phase = .countdown(5) }
    }

    /// Reparte como en una mesa real: una carta a cada jugador por vuelta y, al final, se descubre la primera.
    private func deal() {
        let step = 0.09
        var moves: [CardFlight] = []
        for round in 0..<7 {
            for player in game.hands.indices where game.hands[player].indices.contains(round) {
                moves.append(CardFlight(card: game.hands[player][round], from: .deck, to: .seat(player),
                                        delay: Double(moves.count) * step, faceUp: player == 0))
            }
        }
        if let first = game.discard.last {
            moves.append(CardFlight(card: first, from: .deck, to: .center, delay: Double(moves.count) * step + 0.2, faceUp: true))
        }
        launch(moves)
    }

    /// Aplica una jugada y lanza la animación de cada carta que cambia de sitio.
    private func perform(_ change: (inout BattleGame) -> Void) {
        let before = game
        let mover = game.current
        withAnimation(.spring) { change(&game) }
        var moves: [CardFlight] = []
        if let card = game.discard.last, card.id != before.discard.last?.id {
            moves.append(CardFlight(card: card, from: .seat(mover), to: .center, faceUp: true))
        }
        // Las cartas robadas (o de castigo tras un +2/+4) salen del mazo después de la jugada.
        let base = moves.isEmpty ? 0 : 0.3
        for player in game.hands.indices {
            let previous = Set(before.hands[player].map(\.id))
            let drawn = game.hands[player].filter { !previous.contains($0.id) }
            for (index, card) in drawn.enumerated() {
                moves.append(CardFlight(card: card, from: .deck, to: .seat(player),
                                        delay: base + Double(index) * 0.12, faceUp: player == 0))
            }
        }
        launch(moves)
    }

    private func launch(_ moves: [CardFlight]) {
        flights += moves
        for move in moves {
            Task {
                try? await Task.sleep(for: .seconds(move.delay + CardFlight.duration))
                withAnimation(.spring(duration: 0.3)) { flights.removeAll { $0.id == move.id } }
            }
        }
    }
}

// MARK: - Online

@MainActor @Observable
private final class OnlineCardsModel {
    var room: CardRoomState?
    var error: String?
    var busy = false
    private let client = BackendClient()
    func request(path: String, method: String = "POST", body: Data? = nil) async {
        guard !busy else { return }
        busy = true; defer { busy = false }
        do {
            guard let session = SessionStore.shared.credential, session.expiresAt > Date().timeIntervalSince1970 else {
                throw FavoriteStoreError.signInRequired
            }
            let data = try await client.send(method, path: path, token: session.token, body: body)
            let updated = try JSONDecoder().decode(CardRoomState.self, from: data)
            if room == nil || updated.code != room?.code || updated.version >= (room?.version ?? 0) { room = updated }
            error = nil
        } catch BackendError.http(let status) {
            self.error = switch status {
            case 401: "Tu sesión ha caducado. Vuelve a iniciar sesión."
            case 404: "La sala no existe o ha caducado."
            case 403: "No tienes acceso a esta sala."
            case 409: "La sala está completa, faltan jugadores o cambió el turno."
            case 429: "Ya tienes cinco salas activas. Reutiliza una existente."
            default: "No se pudo conectar con la sala (\(status))."
            }
        } catch { self.error = error.localizedDescription }
    }
    func action(card: BattleCard? = nil, color: BattleColor? = nil, draw: Bool = false) async {
        guard let room else { return }
        do {
            let body = try JSONEncoder().encode(CardRoomAction(version: room.version, cardID: card?.id, color: color, draw: draw))
            await request(path: "v1/rooms/\(room.code)/actions", body: body)
        } catch { self.error = error.localizedDescription }
    }
}

struct BattleOnlineView: View {
    @State private var model = OnlineCardsModel()
    @State private var code = ""
    @State private var pendingCard: BattleCard?
    @State private var showsLogin = false
    @State private var showsRules = false
    @Environment(SessionStore.self) private var session
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                if let room = model.room, room.started, let current = room.current, let color = room.color {
                    BattleTable(hand: room.hand, counts: room.counts, seat: room.seat, current: current,
                                winner: room.winner, top: room.top, activeColor: color, message: room.message,
                                playable: room.playable, online: true, busy: model.busy,
                                play: { card in
                                    if card.color == nil { pendingCard = card } else { Task { await model.action(card: card) } }
                                }, draw: { Task { await model.action(draw: true) } }, restart: {})
                } else if let room = model.room {
                    VStack(spacing: 20) {
                        Text("Sala \(room.code)").font(.title2.bold()).textSelection(.enabled)
                        ShareLink("Compartir código", item: room.code)
                        Text("\(room.players) de 4 jugadores")
                        Text("Comparte el código con otros tres jugadores. Todos deben iniciar sesión.").multilineTextAlignment(.center)
                        if room.seat == 0 {
                            Button("Empezar partida") { Task { await model.request(path: "v1/rooms/\(room.code)/start") } }
                                .buttonStyle(.borderedProminent).disabled(room.players != 4 || model.busy)
                        }
                    }.padding().frame(maxHeight: .infinity)
                } else {
                    VStack(spacing: 20) {
                        Text("Cartas online").font(.largeTitle.bold())
                        Text("Crea una sala privada para cuatro jugadores o entra con un código.").multilineTextAlignment(.center)
                        if session.userID == nil {
                            Button("Iniciar sesión") { showsLogin = true }.buttonStyle(.borderedProminent)
                        } else {
                            Button("Crear sala") { Task { await model.request(path: "v1/rooms") } }.buttonStyle(.borderedProminent)
                            TextField("Código de sala", text: $code).textInputAutocapitalization(.characters).autocorrectionDisabled().textFieldStyle(.roundedBorder)
                            Button("Entrar / reconectar") {
                                let cleaned = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                                Task { await model.request(path: "v1/rooms/\(cleaned)/join") }
                            }.disabled(code.trimmingCharacters(in: .whitespacesAndNewlines).count != 10)
                        }
                    }.padding().frame(maxHeight: .infinity).disabled(model.busy)
                }
                if let error = model.error { Text(error).font(.caption).foregroundStyle(.red).padding(8) }
            }
            .background(LinearGradient(
                gradient: Gradient(colors: [.backgroundColorEX, .backgroundColor]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .navigationTitle(model.room.map { "Sala \($0.code)" } ?? "Online").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.backward")
                                .bold()

                            Text("Volver")
                                .font(.callout)
                        }
                    }
                }

                ToolbarItem(placement: .automatic) {
                    Button {
                        showsRules = true
                    } label: {
                        Label("Reglas", systemImage: "book.fill")
                    }
                }
            }
            .alert("Reglas", isPresented: $showsRules) { Button("Entendido", role: .cancel) {} } message: { Text(battleRules) }
            .sheet(isPresented: $showsLogin) { LoginView() }
            .confirmationDialog("Elige el color", isPresented: Binding(get: { pendingCard != nil }, set: { if !$0 { pendingCard = nil } }), titleVisibility: .visible) {
                ForEach(BattleColor.allCases, id: \.self) { color in
                    Button(color.rawValue) {
                        if let card = pendingCard { Task { await model.action(card: card, color: color) } }
                        pendingCard = nil
                    }
                }
            }
            .task(id: "\(model.room?.code ?? "")-\(scenePhase)") {
                guard let room = model.room, scenePhase == .active else { return }
                while !Task.isCancelled && model.room?.winner == nil {
                    do { try await Task.sleep(for: .seconds(2)) } catch { return }
                    guard !Task.isCancelled else { return }
                    await model.request(path: "v1/rooms/\(room.code)", method: "GET")
                }
            }
        }
    }
}

#Preview {
    BattleCardsView()
}
