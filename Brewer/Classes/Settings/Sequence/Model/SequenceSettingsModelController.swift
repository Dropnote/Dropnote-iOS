//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import XCGLogger
import ObjectMapper
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


enum SequenceStepFilter {
    case all
    case active
}

protocol SequenceSettingsModelControllerType {
    func sequenceStepsForBrewMethod(_ brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep]
    func saveSequenceStepsForBrewMethod(_ brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep])
}

final class SequenceSettingsModelController: SequenceSettingsModelControllerType {
    struct Keys {
        static let brewingSequence = "BrewingSequenceSettingsKey"
    }
    
    fileprivate let store: KeyValueStoreType
    fileprivate let brewingSequenceMapper = Mapper<BrewingSequenceStep>()
    fileprivate(set) var brewingSequenceSettings: Dictionary<BrewMethod, [BrewingSequenceStep]> = [:]

    init(store: KeyValueStoreType) {
        self.store = store
        presetDefaultSettings()
        loadSettings()
    }

    func sequenceStepsForBrewMethod(_ brewMethod: BrewMethod, filter: SequenceStepFilter) -> [BrewingSequenceStep] {
        return brewingSequenceSettings[brewMethod]?
            .filter { filter == .all ? true : $0.enabled! }
            .sorted { $0.position < $1.position } ?? []
    }

    func saveSequenceStepsForBrewMethod(_ brewMethod: BrewMethod, sequenceSteps: [BrewingSequenceStep]) {
        brewingSequenceSettings[brewMethod] = sequenceSteps
        saveSettings()
    }

    // MARK: Settings saving

    fileprivate func saveSettings() {
        var rawSeqenceSettings: Dictionary<String, String> = [:]
        brewingSequenceSettings.forEach {
            method, steps in
            rawSeqenceSettings[method.rawValue] = brewingSequenceMapper.toJSONString(steps)
        }
        store.set(rawSeqenceSettings, forKey: Keys.brewingSequence)
        _ = store.synchronize()
    }

    // MARK: Settings loading

    fileprivate func loadSettings() {
        guard let rawSequenceSettings = store.object(forKey: Keys.brewingSequence) as? Dictionary<String, String> else {
            XCGLogger.error("Can't load settings!")
            return
        }
        rawSequenceSettings.forEach {
            brewingSequenceSettings[BrewMethod(rawValue: $0)!] = brewingSequenceMapper.mapArray(JSONString: $1) ?? []
        }
    }

    // MARK: Default settings

    fileprivate func presetDefaultSettings() {
        if store.object(forKey: Keys.brewingSequence) == nil {

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
            store.set(defaultSeqenceSettings, forKey: Keys.brewingSequence)
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

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        type <- map["type"]
        position <- map["position"]
        enabled <- map["enabled"]
    }

    mutating func setEnabled(_ enabled: Bool) {
        self.enabled = enabled
    }

    mutating func setPosition(_ position: Int) {
        self.position = position
    }
}
