//
//  CoreDataEntity.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/5/25.
//

import Foundation
import CoreData

protocol CoreDataEntity: NSManagedObject {
    static var entityName: String { get }
}

extension CDTextRecord: CoreDataEntity {
    static var entityName: String { "\(self)" }
}
