//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import Swinject
import CoreSpotlight

final class CoreComponentsAssembly: AssemblyType {
    func assemble(container: Container) {
        
        container.register(StackType.self) {
            _ in CoreDataStack(storeType: isRunningTests() ? NSInMemoryStoreType : NSSQLiteStoreType)
        }.inObjectScope(.container)

        container.register(KeyValueStoreType.self) {
            _ in UserDefaults.standard
        }
        
        container.register(ThemeConfiguration.self) {
            _ in MainThemeConfiguration()
        }
        
        container.register(RootViewController.self) {
            r in
            return RootViewController(viewControllers: [
                    r.resolve(MethodPickerViewController.self)!,
                    r.resolve(BrewingsViewController.self)!,
                    r.resolve(SettingsViewController.self)!
            ], themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(SpotlightSearchService.self) {
            _ in SpotlightSearchService(searchableIndex: CSSearchableIndex.default())
        }
    }
}
