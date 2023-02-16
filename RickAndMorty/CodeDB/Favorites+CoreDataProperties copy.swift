//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by andrey perevedniuk on 16.02.2023.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var characterId: String?
    @NSManaged public var name: String?
    @NSManaged public var locationName: String?
    @NSManaged public var user: UserEntity?

}
