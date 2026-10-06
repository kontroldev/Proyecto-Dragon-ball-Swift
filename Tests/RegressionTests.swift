import Foundation
import SwiftUI

@MainActor
final class FakeFavoriteStore: FavoriteCharacterStoring {
    var userID: String? = "alice"
    var fails = false
    var saved: [FavoriteCharacter] = []
    var pendingRead: CheckedContinuation<[FavoriteCharacter], Error>?
    var suspendsRead = false

    func addToFavorites(character: FavoriteCharacter) async throws {
        if fails { throw FavoriteStoreError.signInRequired }
        saved.append(character)
    }
    func deleteFavoriteCharacter(characterID: Int) async throws {
        if fails { throw FavoriteStoreError.signInRequired }
        saved.removeAll { $0.characterID == characterID }
    }
    func getFavorites() async throws -> [FavoriteCharacter] {
        if suspendsRead { return try await withCheckedThrowingContinuation { pendingRead = $0 } }
        return saved
    }
}
// The production adapter needs Firebase. Tests inject the fake through the same contract.
typealias APIFavoriteStore = FakeFavoriteStore

@MainActor
final class StubNetworkClient: NetworkClientProtocol {
    var pages: [Int] = []
    func call<T: Decodable>(
        urlString: String, method: NetworkMethod,
        queryParams: [String: Any]?, of type: T.Type
    ) async throws -> T {
        let page = queryParams?["page"] as? Int ?? 1
        pages.append(page)
        let ids = page == 1 ? [1, 2] : [2, 3]
        let items = ids.map { character($0) }
        let response = Characters(
            items: items,
            meta: Meta(totalItems: 3, itemCount: 2, itemsPerPage: 2, totalPages: 2, currentPage: page),
            links: Links(first: nil, previous: nil, next: nil, last: nil))
        return response as! T
    }
}

@MainActor
final class StubCatalog: CharacterCatalogProviding {
    func fetchCharacters() async throws -> Characters {
        Characters(
            items: [character(1), character(2)],
            meta: Meta(totalItems: 2, itemCount: 2, itemsPerPage: 2, totalPages: 1, currentPage: 1),
            links: Links(first: nil, previous: nil, next: nil, last: nil))
    }
}

func character(_ id: Int) -> Character {
    Character(
        id: id, name: id == 1 ? "Goku" : "Vegeta", ki: "1", maxKi: "2", race: "Saiyan",
        gender: "Male", description: "Descripción", image: "https://example.com/image.png",
        affiliation: "Z Fighter", deletedAt: nil)
}

actor StubURLSession: URLSessionProtocol {
    let status: Int
    let cancelled: Bool
    init(status: Int = 200, cancelled: Bool = false) {
        self.status = status
        self.cancelled = cancelled
    }
    func getDataFrom(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if cancelled { throw URLError(.cancelled) }
        return (
            Data("{}".utf8),
            HTTPURLResponse(
                url: request.url!, statusCode: status,
                httpVersion: nil, headerFields: nil)!
        )
    }
}

@main
struct RegressionTests {
    @MainActor static func main() async throws {
        expect(
            SongResource(name: "__missing_audio_regression__").url == nil,
            "Un archivo de audio ausente no provoca un cierre")
        do {
            let _: Meta = try await NetworkClient(urlSession: StubURLSession(status: 401))
                .call(urlString: "https://example.com", method: .get, of: Meta.self)
            preconditionFailure("Debe propagar el error HTTP")
        } catch ApiError.httpError(let status) {
            expect(status == 401, "Un error de autenticación no se describe como 404")
        }
        do {
            let _: Meta = try await NetworkClient(urlSession: StubURLSession(cancelled: true))
                .call(urlString: "https://example.com", method: .get, of: Meta.self)
            preconditionFailure("Debe propagar la cancelación")
        } catch is CancellationError {
            expect(true, "Una cancelación no se presenta como fallo de conexión")
        }
        let detailJSON =
            #"{"id":1,"name":"Goku","ki":"1","maxKi":"2","race":"Saiyan","gender":"Male","description":"Descripción","image":"https://example.com/goku.png","affiliation":"Z Fighter","originPlanet":null,"transformations":[{"id":2,"name":"Super Saiyan","image":"https://example.com/form.png","ki":"3"}]}"#
        let detail = try JSONDecoder().decode(SingleCharacter.self, from: Data(detailJSON.utf8))
        expect(
            detail.toCharactersModel().transformations.count == 1 && detail.originPlanet == nil,
            "Decodifica planeta ausente y conserva transformaciones")
        let network = StubNetworkClient()
        let catalog = try await CharacterCatalogService(networkClient: network).fetchCharacters()
        expect(network.pages == [1, 2], "Consulta todas las páginas")
        expect(catalog.items.map(\.id) == [1, 2, 3], "Elimina duplicados entre páginas")
        let mapped = character(1).toCharactersModel()
        expect(mapped.planet.isEmpty && mapped.affiliation == "Z Fighter", "No confunde afiliación y planeta")
        let viewModel = CharactersViewModel(
            referent: "all", logo: "", sagas: "", charactersService: StubCatalog())
        expect(viewModel.searchCharacters(characterName: "goku").isEmpty, "Consulta antes de cargar")
        await viewModel.getCharacters()
        expect(
            viewModel.searchCharacters(characterName: " GOKU ").count == 1,
            "La búsqueda se actualiza tras cargar")
        expect(
            viewModel.searchCharacters(characterName: "sin coincidencias").isEmpty,
            "No sustituye resultados vacíos")

        let store = FakeFavoriteStore()
        let favorites = FavoritesViewModel(charactersService: StubCatalog(), store: store)
        store.fails = true
        await favorites.addToFavorites(characterID: 1)
        expect(!favorites.isFavorite(characterID: 1), "Una escritura fallida no marca el favorito")
        store.fails = false
        await favorites.addToFavorites(characterID: 1)
        await favorites.addToFavorites(characterID: 1)
        expect(favorites.favoriteCharactersIDs.count == 1, "No duplica favoritos")
        store.fails = true
        let removed = await favorites.removeFromFavorites(characterID: 1)
        expect(
            !removed && favorites.isFavorite(characterID: 1), "Una eliminación fallida conserva el favorito")
        store.fails = false
        store.suspendsRead = true
        let load = Task { await favorites.getFavoriteCharactersIDs() }
        while store.pendingRead == nil { await Task.yield() }
        store.userID = "bob"
        favorites.resetForSession()
        store.pendingRead?.resume(returning: [FavoriteCharacter(characterID: 1)])
        await load.value
        expect(favorites.favoriteCharactersIDs.isEmpty, "Una respuesta antigua no contamina la nueva sesión")

        let memory = MemoryGameViewModel()
        memory.resetGameAll(cardList: memory.createCardList())
        memory.checkForMatch()
        expect(memory.score == 0, "Comprobar sin pareja no accede fuera de rango")
        let first = memory.cardList[0]
        memory.choose(first)
        memory.choose(first)
        expect(memory.userChoices.count == 1, "No selecciona dos veces la misma carta")
        let second = memory.cardList.first { $0.text != first.text }!
        memory.choose(second)
        memory.choose(memory.cardList.first { $0.id != first.id && $0.id != second.id }!)
        expect(memory.userChoices.count == 2, "Bloquea una tercera selección")
        memory.resetGameAll(cardList: memory.cardList)
        try await Task.sleep(for: .seconds(1))
        expect(
            memory.attempts == 0 && memory.cardList.allSatisfy { !$0.isFaceUp },
            "Reiniciar cancela una pareja pendiente")
        expect(!memory.gameOver(10), "Primer nivel sin límite de intentos")
        memory.difficulty = .level_2
        expect(memory.gameOver(10), "Segundo nivel con límite de intentos")

        let tetris = TetrisViewModel()
        let shape = IShape()
        expect(tetris.isInValidPosition(shape: shape), "Permite la entrada de una pieza desde arriba")
        tetris.storeShapeInGrid(shape: shape)
        expect(tetris.gameIsOver, "No escribe coordenadas negativas al fijar una pieza")
        tetris.restartGame()
        tetris.gameIsStopped = true
        let positions = tetris.activeShape!.occuppiedPositions.map { "\($0.x),\($0.y)" }
        tetris.moveLeft()
        expect(
            positions == tetris.activeShape!.occuppiedPositions.map { "\($0.x),\($0.y)" },
            "La pausa bloquea controles")
        tetris.cancellableSet.removeAll()
        print("Todas las pruebas de regresión han pasado.")
    }

    static func expect(_ condition: Bool, _ message: String) {
        precondition(condition, message)
        print("✓ \(message)")
    }
}
