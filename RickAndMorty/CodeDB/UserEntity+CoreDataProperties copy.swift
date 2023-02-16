//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by andrey perevedniuk on 16.02.2023.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var favorite: NSSet?

}

// MARK: Generated accessors for favorite
extension UserEntity {

    @objc(addFavoriteObject:)
    @NSManaged public func addToFavorite(_ value: Favorites)

    @objc(removeFavoriteObject:)
    @NSManaged public func removeFromFavorite(_ value: Favorites)

    @objc(addFavorite:)
    @NSManaged public func addToFavorite(_ values: NSSet)

    @objc(removeFavorite:)
    @NSManaged public func removeFromFavorite(_ values: NSSet)

}
