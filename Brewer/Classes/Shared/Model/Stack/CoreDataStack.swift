//
// Created by Maciej Oczko on 23.11.2015.
// Copyright (c) 2015 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol StackType {
    var mainContext: NSManagedObjectContext { get }

    func createPrivateContext() -> NSManagedObjectContext
    
    func asyncOperation(operation: (NSManagedObjectContext) -> ())

    func asyncBackgroundOperation(operation: (NSManagedObjectContext) -> ())
    func backgroundOperation(operation: (NSManagedObjectContext) -> ()) -> Observable<Bool>

    func save() -> Observable<Bool>
}

class CoreDataStack: StackType {
    private(set) var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    private var writingContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)

    init(storeType: String = NSSQLiteStoreType) {
        writingContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        mainContext.parentContext = writingContext

        initializeSQLite(storeType)
    }
    
    // MARK: Public methods

    func save() -> Observable<Bool> {
        if (!writingContext.hasChanges && !mainContext.hasChanges) {
            return Observable.just(true)
        }

        return saveContext(self.mainContext).flatMap {
            _ in
            return self.saveContext(self.writingContext)
        }
    }

    func createPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.mainContext
        return context
    }

    func asyncBackgroundOperation(operation: (NSManagedObjectContext) -> ()) {
        let context = createPrivateContext()
        context.performBlock {
            operation(context)
        }
    }

    func backgroundOperation(operation: (NSManagedObjectContext) -> ()) -> Observable<Bool> {
        return Observable.create {
            observer in
            let context = self.createPrivateContext()
            context.performBlock {
                operation(context)
                observer.onNext(true)
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
    
    func asyncOperation(operation: (NSManagedObjectContext) -> ()) {
        let context = mainContext
        context.performBlock {
            operation(context)
        }
    }

    // MARK: Private methods

    private func saveContext(context: NSManagedObjectContext) -> Observable<Bool> {
        return Observable.create {
            observer in

            context.performBlock() {
                do {
                    try context.save()
                    observer.onNext(true)
                    observer.onCompleted()
                } catch {
                    observer.on(.Error(error))
                }
            }

            return NopDisposable.instance
        }
    }

    // MARK: Stack setup

    private func initializeSQLite(storeType: String) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Brewer.sqlite")
            let failureReason = "There was an error creating or loading the application's saved data."
            do {
                let options = [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                ]
                try self.persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: url, options: options)
            } catch {
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "pl.maciejoczko.brewer", code: 9999, userInfo: dict)
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
        }
    }

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("Brewer", withExtension: "mom")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()

    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
}
