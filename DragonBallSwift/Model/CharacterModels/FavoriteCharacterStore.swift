import Foundation

@MainActor
protocol FavoriteCharacterStoring {
    var userID: String? { get }
    func addToFavorites(character: FavoriteCharacter) async throws
    func getFavorites() async throws -> [FavoriteCharacter]
    func deleteFavoriteCharacter(characterID: Int) async throws
}

enum FavoriteStoreError: LocalizedError {
    case signInRequired

    var errorDescription: String? { "Inicia sesión para guardar tus favoritos." }
}
