//
// Created by Maciej Oczko on 18.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

extension UnitCategory {
    func defaultSetting() -> Int {
        switch self {
        case .Weight: return UnitCategory.WeightUnit.g.rawValue
        case .Water: return UnitCategory.WaterUnit.g.rawValue
        case .Temperature: return UnitCategory.TemperatureUnit.Celsius.rawValue
        }
    }
}
