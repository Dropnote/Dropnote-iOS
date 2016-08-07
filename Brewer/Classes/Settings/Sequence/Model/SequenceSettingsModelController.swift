//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger
import ObjectMapper

enum SequenceStepFilter {
    case All
    case Active
}

protocol SequenceSettingsModelControllerType {
    func sequenceStepsForBrewMethod(brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep]
    func saveSequenceStepsForBrewMethod(brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep])
}

final class SequenceSettingsModelController: SequenceSettingsModelControllerType {
    struct Keys {
        static let brewingSequence = "BrewingSequenceSettingsKey"
    }
    
    private let store: KeyValueStoreType
    private let brewingSequenceMapper = Mapper<BrewingSequenceStep>()
    private(set) var brewingSequenceSettings: Dictionary<BrewMethod, [BrewingSequenceStep]> = [:]

    init(store: KeyValueStoreType) {
        self.store = store
        presetDefaultSettings()
        loadSettings()
    }

    func sequenceStepsForBrewMethod(brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep] {
        return brewingSequenceSettings[brewMethod]?
            .filter { filter == .All ? true : $0.enabled! }
            .sort { $0.position < $1.position } ?? []
    }

    func saveSequenceStepsForBrewMethod(brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep]) {
        brewingSequenceSettings[brewMethod] = sequenceSteps
        saveSettings()
    }

    // MARK: Settings saving

    private func saveSettings() {
        var rawSeqenceSettings: Dictionary<String, String> = [:]
        brewingSequenceSettings.forEach {
            method, steps in
            rawSeqenceSettings[method.rawValue] = brewingSequenceMapper.toJSONString(steps)
        }
        store.setObject(rawSeqenceSettings, forKey: Keys.brewingSequence)
        store.synchronize()
    }

    // MARK: Settings loading

    private func loadSettings() {
        guard let rawSequenceSettings = store.objectForKey(Keys.brewingSequence) as? Dictionary<String, String> else {
            XCGLogger.error("Can't load settings!")
            return
        }
        rawSequenceSettings.forEach {
            brewingSequenceSettings[BrewMethod(rawValue: $0)!] = brewingSequenceMapper.mapArray($1) ?? []
        }
    }

    // MARK: Default settings

    private func presetDefaultSettings() {
        if store.objectForKey(Keys.brewingSequence) == nil {

            var defaultSeqenceSettings: Dictionary<String, String> = [:]
            for method in BrewMethod.allValues {
                let sequenceSteps = BrewAttributeType.allValues.map {
                    BrewingSequenceStep(
                        type: $0,
                        position: $0.defaultPosition(forMethod: method),
                        enabled: $0.defaultEnabled(forMethod: method)
                    )
                }
                defaultSeqenceSettings[method.rawValue] = brewingSequenceMapper.toJSONString(sequenceSteps)
            }
            store.setObject(defaultSeqenceSettings, forKey: Keys.brewingSequence)
        }
    }
}

struct BrewingSequenceStep: Mappable {
    var type: BrewAttributeType?
    var position: Int?
    var enabled: Bool?

    init(type: BrewAttributeType?, position: Int?, enabled: Bool?) {
        self.type = type
        self.position = position
        self.enabled = enabled
    }

    init?(_ map: Map) {

    }

    mutating func mapping(map: Map) {
        type <- map["type"]
        position <- map["position"]
        enabled <- map["enabled"]
    }

    mutating func setEnabled(enabled: Bool) {
        self.enabled = enabled
    }

    mutating func setPosition(position: Int) {
        self.position = position
    }
}
