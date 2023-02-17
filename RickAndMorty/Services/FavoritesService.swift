//
//  FavoriteService.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//

import Foundation

protocol FavoritesServiceProtocol: AnyObject {
    func getFavorites(user: UserEntity) -> [FavoriteEntity]
    func addToFavorite(item: CharacterModel, user: UserEntity) throws -> Void
    func removeFromFavorite(item: CharacterModel) throws -> Void
}

class FavoritesService: FavoritesServiceProtocol {
    private let dbManager = CoreDataManager.shared
    
    func getFavorites(user: UserEntity) -> [FavoriteEntity] {
        let result = try? dbManager.getData(entityName: "FavoriteEntity", predicate: nil, sort: nil) as? [FavoriteEntity]
        return result?.filter { $0.user == user } ?? []
    }
    
    func addToFavorite(item: CharacterModel, user: UserEntity) throws {
        let favorite = characterToFavorite(item: item)
        favorite.user = user
        try dbManager.insert(favorite)
    }
    
    func removeFromFavorite(item: CharacterModel) throws {
        let result = try? dbManager.getData(entityName: "FavoriteEntity", predicate: nil, sort: nil) as? [FavoriteEntity]
        if let favorite = result?.first(where: { $0.characterId == String(item.id) }) {
            try dbManager.delete(favorite)
        }
    }
    
    private func characterToFavorite(item: CharacterModel) -> FavoriteEntity {
        let favorite = FavoriteEntity(context: dbManager.context)
        favorite.id = UUID()
        favorite.characterId = String(item.id)
        favorite.name = item.name
        favorite.locationName = item.location.name
        favorite.imageUrl = item.image
        return favorite
    }
}
