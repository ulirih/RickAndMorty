//
//  ChartersListModel.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import Foundation

struct CharactersListModel: Codable {
    let info: CharactersListInfo
    let results: [CharacterModel]
}

struct CharactersListInfo: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
