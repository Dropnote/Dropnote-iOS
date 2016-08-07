//
// Created by Maciej Oczko on 17.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import XCGLogger

protocol BrewingsModelControllerType {
	var fetchedResultsController: NSFetchedResultsController { get }
    var sortingOption: BrewingSortingOption { get set }
	func setSearchText(search: String?)
}

final class BrewingsModelController: BrewingsModelControllerType {
	let stack: StackType
    private let isFinishedPredicate = NSPredicate(format: "isFinished == %@", true)
    
    var sortingOption: BrewingSortingOption = .DateDescending {
        didSet {
            fetchedResultsController.fetchRequest.sortDescriptors = [sortingOption.sortDescriptor]
            do {
                try fetchedResultsController.performFetch()
            } catch {
                XCGLogger.error("Error when fetching brews = \(error)")
            }
        }
    }

	lazy var fetchedResultsController: NSFetchedResultsController = {
		let fetchRequest = NSFetchRequest(entityName: Brew.entityName())
		fetchRequest.sortDescriptors = [self.sortingOption.sortDescriptor]
		fetchRequest.predicate = self.isFinishedPredicate
		let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.stack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        do {
            try fetchedResultsController.performFetch()
        } catch {
            XCGLogger.error("Error when fetching brews = \(error)")
        }
		
		return fetchedResultsController
	}()

	init(stack: StackType) {
		self.stack = stack
	}

	func setSearchText(search: String?) {
		var searchPredicate: NSPredicate?
		if let search = search where !search.isEmpty {
            searchPredicate = NSPredicate(format: "coffee.name CONTAINS[c] %@", search)
		}

		fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
			isFinishedPredicate,
			searchPredicate ?? NSPredicate.truePredicate(),
		])
        
		do {
			try fetchedResultsController.performFetch()
            if let didChangeContent = fetchedResultsController.delegate?.controllerDidChangeContent {
                didChangeContent(fetchedResultsController)
            }            
		} catch {
			XCGLogger.error("Error when filtering brews = \(error)")
		}
	}
}
