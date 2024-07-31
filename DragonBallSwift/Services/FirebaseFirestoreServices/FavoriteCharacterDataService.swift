//
//  FavoriteCharacterDataService.swift
//  DragonBallSwift
//
//  Created by Jacob Aguilar on 31-07-24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class FavoriteCharacterDataBaseService {
    private let database = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid ?? ""
    private let usersCollection = "users"
    private let favoriteCharactersCollection = "favoriteCharacters"
    
    private var listener: ListenerRegistration?
    
    
    func addToFavorites(character: FavoriteCharacter) async throws {
        do {
            try await database.collection(usersCollection).document(uid).collection(favoriteCharactersCollection).document(character.characterID).setData(character.dictionary)
        } catch {
            throw error
        }
    }
    
    func getFavorites() async throws  -> [FavoriteCharacter] {
        do {
            let snapshot = try await database.collection(usersCollection).document(uid).collection(favoriteCharactersCollection).getDocuments()
            let documents = snapshot.documents
            let favorites = documents.map { try! $0.data(as: FavoriteCharacter.self) }.compactMap { $0 }
            
            return favorites
        } catch {
            throw error
        }
    }
}
