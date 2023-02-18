//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import Foundation

struct CharacterModel: Codable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }
}

enum Gender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

struct Location: Codable, Hashable {
    let name: String
    let url: String
}

enum CharacterStatus: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
