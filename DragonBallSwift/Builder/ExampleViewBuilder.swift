import Foundation

@MainActor
final class ExampleViewBuilder {
    func build() -> DragonBallView {
        DragonBallView(referent: "all", logo: "DBLogo", sagas: "Personajes")
    }
}
