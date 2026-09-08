//
//  CharacterMapping.swift
//  DragonBallSwift
//
//  Convierte el modelo `Character` (dragonball-api.com) al modelo
//  `CharactersModel` que ya usan las vistas de la app.
//

import Foundation

extension Character {
    /// La API de dragonball-api.com no devuelve planeta, biografía ni
    /// transformaciones en el listado general, así que se rellenan con
    /// lo más cercano disponible (`affiliation` como planeta/afiliación,
    /// la descripción como biografía y sin transformaciones).
    func toCharactersModel() -> CharactersModel {
        CharactersModel(
            id: id,
            name: name,
            genre: gender,
            race: race,
            image: image,
            planet: affiliation,
            description: description,
            biography: description,
            transformations: []
        )
    }
}
