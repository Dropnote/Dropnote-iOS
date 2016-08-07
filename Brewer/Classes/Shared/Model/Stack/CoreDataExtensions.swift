//
// Created by Maciej Oczko on 16.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

protocol Entity {
    static func entityName() -> String
}

struct CoreDataOperations<T where T: NSManagedObject, T: Entity> {
    let context: NSManagedObjectContext

    init(managedObjectContext context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(T.entityName(), inManagedObjectContext: context) as! T
    }
    
    func fetch(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = NSFetchRequest(entityName: T.entityName())
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        return try context.executeFetchRequest(fetchRequest) as! [T]
    }

    func save() throws {
        try context.save()
    }
    
    func objectForID(objectID: NSManagedObjectID) -> T? {
        return context.objectRegisteredForID(objectID) as? T
    }
}

extension NSFetchedResultsController {
    
    func fetchedItems<T: AnyObject>() -> [T] {
        return (fetchedObjects ?? []) as! [T]
    }
}
