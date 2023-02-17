//
//  FavoriteEntity+CoreDataProperties.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var characterId: String?
    @NSManaged public var name: String?
    @NSManaged public var locationName: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var user: UserEntity?

}

extension FavoriteEntity : Identifiable {

}
