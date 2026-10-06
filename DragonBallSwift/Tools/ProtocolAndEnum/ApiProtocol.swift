import Foundation

@MainActor
protocol CharacterCatalogProviding {
    func fetchCharacters() async throws -> Characters
}

@MainActor
protocol SingleCharacterProtocol {
    func fetchCharacter(id: Int) async throws -> SingleCharacter
}
