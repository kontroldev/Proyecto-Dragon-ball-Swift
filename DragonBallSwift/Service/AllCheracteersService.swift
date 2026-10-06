//
//  CharacterCatalogService.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

/// Carga todas las páginas para filtrar sobre el catálogo completo.
final class CharacterCatalogService: CharacterCatalogProviding {
    private let networkClient: NetworkClientProtocol
    private let endpoint = "https://dragonball-api.com/api/characters"

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchCharacters() async throws -> Characters {
        var page = 1
        var items: [Character] = []
        var seenIDs: Set<Int> = []
        var response: Characters
        repeat {
            try Task.checkCancellation()
            response = try await networkClient.call(
                urlString: endpoint, method: .get,
                queryParams: ["page": page, "limit": 50], of: Characters.self
            )
            items += response.items.filter { seenIDs.insert($0.id).inserted }
            page += 1
        } while page <= response.meta.totalPages
        return Characters(items: items, meta: response.meta, links: response.links)
    }
}
