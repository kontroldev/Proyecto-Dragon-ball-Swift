//
//  AllCheratersModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 29/5/24.
//

import Foundation

// MARK: - Character
struct Characters: Codable {
    let items: [Character]
    let meta: Meta
    let links: Links
}

// MARK: - Item
struct Character: Codable {
    let id: Int
    let name, ki, maxKi, race: String
    let gender, description: String
    let image: String
    let affiliation: String
    let deletedAt: Date?
}

// MARK: - Links
struct Links: Codable {
    let first: String
    let previous: String
    let next, last: String
}

// MARK: - Meta
struct Meta: Codable {
    let totalItems, itemCount, itemsPerPage, totalPages: Int
    let currentPage: Int
}


// MARK: - View Card
extension [Character]{
    func zIndex(_ item: Character) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id}){
            return CGFloat(count) - CGFloat(index)
        }
        return .zero
    }
}
