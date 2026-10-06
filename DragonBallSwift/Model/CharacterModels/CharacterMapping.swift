import Foundation

extension Character {
    /// El listado no incluye planeta de origen ni transformaciones.
    func toCharactersModel() -> CharactersModel {
        CharactersModel(
            id: id, name: name, genre: gender, race: race, image: image,
            planet: "", description: description, biography: "",
            transformations: [], affiliation: affiliation)
    }
}

extension SingleCharacter {
    func toCharactersModel() -> CharactersModel {
        CharactersModel(
            id: id, name: name, genre: gender, race: race, image: image,
            planet: originPlanet?.name ?? "", description: description,
            biography: "",
            transformations: transformations.map {
                Transformation(
                    id: $0.id, title: $0.name, image: $0.image,
                    description: "Ki: \($0.ki)")
            }, affiliation: affiliation)
    }
}
