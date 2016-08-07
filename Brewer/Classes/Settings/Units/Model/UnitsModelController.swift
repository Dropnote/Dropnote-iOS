//
// Created by Maciej Oczko on 18.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger

protocol UnitsModelControllerType {
    func rawUnit(forCategory rawCategory: Int) -> Int
    func setRawUnit(rawUnit: Int, forCategory rawCategory: Int)
}

final class UnitsModelController: UnitsModelControllerType {
    struct Keys {
        static let units = "UnitsSettingsKey"
    }
    
    private let store: KeyValueStoreType
    private(set) var unitsSettings = [String: Int]()

    init(store: KeyValueStoreType) {
        self.store = store
        presetDefaultSettings()
        loadSettings()
    }

    func rawUnit(forCategory rawCategory: Int) -> Int {
        return unitsSettings[String(rawCategory)]!
    }

    func setRawUnit(rawUnit: Int, forCategory rawCategory: Int) {
        unitsSettings[String(rawCategory)] = rawUnit
        store.setObject(unitsSettings, forKey: Keys.units)
        store.synchronize()
    }

    // MARK: Settings loading

    private func loadSettings() {
        guard let rawUnitsSettings = store.objectForKey(Keys.units) as? Dictionary<String, Int> else {
            XCGLogger.error("Can't load settings!")
            return
        }
        unitsSettings = rawUnitsSettings
    }

    // MARK: Default settings

    private func presetDefaultSettings() {
        if store.objectForKey(Keys.units) == nil {
            let defaultSettings = [
                String(UnitCategory.Water.rawValue) : UnitCategory.Water.defaultSetting(),
                String(UnitCategory.Weight.rawValue) : UnitCategory.Weight.defaultSetting(),
                String(UnitCategory.Temperature.rawValue) : UnitCategory.Temperature.defaultSetting(),
            ]
            store.setObject(defaultSettings, forKey: Keys.units)
            store.synchronize()
        }
    }
}
