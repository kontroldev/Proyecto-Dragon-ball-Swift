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
    
    /// Agrega un personaje a la lista de favoritos del usuario en Firestore.
    /// - Parameters:
    ///     - character: El modelo personaje favorito `FavoriteCharacter` que se agregará a los favoritos.
    /// - Throws: Lanza un error si ocurre un problema al agregar el personaje a Firestore
    func addToFavorites(character: FavoriteCharacter) async throws {
        do {
            try await database.collection(usersCollection).document(uid).collection(favoriteCharactersCollection).document(character.characterID).setData(character.dictionary)
        } catch {
            throw error
        }
    }
    
    /// Obtiene todos los personajes favoritos desde la lista de favoritos del usuario en Firestore
    /// - Returns: Un arreglo `[FavoriteCharacter]` con todos los personajes de la lista de favoritos del usuario
    /// - Throws: Lanza un error si ocurre un problema al obtener la lista de personajes favoritos dese Firestore
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
    
    
     /// Elimina un personaje de la lista de favoritos del usuario en Firestore.
     ///- Parameters:
     ///   - characterID: El ID del personaje que se eliminará de los favoritos.
     ///- Throws: Lanza un error si ocurre un problema al eliminar el personaje de Firestore.
    func deleteFavoriteCharacter(characterID: String) async throws {
        do {
            try await database.collection(usersCollection).document(uid).collection(favoriteCharactersCollection).document(characterID).delete()
        } catch {
            throw error
        }
    }
}
