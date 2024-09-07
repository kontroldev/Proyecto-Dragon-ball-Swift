//
//  UniqueCharacterServer.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 1/8/24.
//

//import Foundation
//
//class SingleCharacterServer: SingleCharacterProtocol {
// 
//    func getSingleCharacter(_ referent: String ,id: String) async throws -> SingleCharacterModel {
//        
//        do {
//            let singleCharacterURL = " https://apidragonball.vercel.app/\(referent)/\(id)"
//            
//            guard let url = URL(string: singleCharacterURL) else {
//                throw ApiError.invalidResponse
//            }
//            
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                throw ApiError.invalidResponse
//            }
//            
//            let decode = JSONDecoder()
//            decode.keyDecodingStrategy = .convertFromSnakeCase
//            return try decode.decode(SingleCharacterModel.self, from: data)
//        }catch{
//            throw error
//        }
//    }
//}
