//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import XCGLogger

protocol SelectableSearchItemInserterType {
    associatedtype Entity
    func insertEntityWithName(name: String) throws -> Entity
}

protocol SelectableSearchModelControllerType {
    var placeholder: String? { get }
    var fetchedResultsController: NSFetchedResultsController! { get }
    func setSearchString(search: String?)
    func setItemIndex(index: Int?)
    func addSearchItem()
    func selectedItemIndex() -> Int?
}

struct SelectableSearchItemInserter<T where T: NSManagedObject, T: Entity, T: SelectableSearchModelItem>: SelectableSearchItemInserterType {
    private let operations: CoreDataOperations<T>

    init(context: NSManagedObjectContext) {
        self.operations = CoreDataOperations(managedObjectContext: context)
    }

    func insertEntityWithName(name: String) throws -> T {
        let items = try operations.fetch(withPredicate: NSPredicate(format: "name == %@", name))
        if let item = items.last {
            return item
        }

        let item = operations.create()
        item.name = name
        try operations.save()
        return item
    }

    func save() throws {
        try operations.save()
    }
}

class SelectableSearchModelController: SelectableSearchModelControllerType {

    let stack: StackType
    let brewModelController: BrewModelControllerType
    
    final var placeholder: String?
    final private(set) var currentSearch: String?

    init(stack: StackType, brewModelController: BrewModelControllerType) {
        self.stack = stack
        self.brewModelController = brewModelController
    }

    final lazy var fetchedResultsController: NSFetchedResultsController! = {
        let fetchRequest = NSFetchRequest(entityName: self.entityName())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.stack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            XCGLogger.error("Error when fetching \(self.entityName()) = \(error)")
        }
        return fetchedResultsController
    }()

    final func setSearchString(search: String?) {
        currentSearch = search
        if let search = search where !search.isEmpty {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "name", search)
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate.truePredicate()
        }
    }
    
    func selectedItemIndex() -> Int? { abstractMethod() }
    
    func entityName() -> String { abstractMethod() }

    func setItemIndex(index: Int?) { abstractMethod() }

    func addSearchItem() { abstractMethod() }
}
