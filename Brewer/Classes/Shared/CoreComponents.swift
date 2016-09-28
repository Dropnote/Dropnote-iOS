//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData
import Swinject

final class CoreComponentsAssembly: AssemblyType {
    func assemble(_ container: Container) {
        container.register(StackType.self) {
            r in CoreDataStack(storeType: isRunningTests() ? NSInMemoryStoreType : NSSQLiteStoreType)
        }.inObjectScope(.Container)

        container.register(KeyValueStoreType.self) {
            r in UserDefaults.standardUserDefaults
        }
        
        container.register(ThemeConfiguration.self) {
            r in MainThemeConfiguration()
        }
        
        container.registerForStoryboard(RootViewController.self) {
            r, c in
            c.resolver = r
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }
    }
}
