//
// Created by Maciej Oczko on 10.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
enum UnitCategory: Int {
    case Water = 1
    case Weight = 2
    case Temperature = 3

    enum WaterUnit: Int {
        case oz = 11, ml = 12, g = 13

        static let allValues = [oz, ml, g]
    }

    enum WeightUnit: Int {
        case oz = 21, g = 22

        static let allValues = [oz, g]
    }

    enum TemperatureUnit: Int {
        case Celsius = 31, Fahrenheit = 32

        static let allValues = [Celsius, Fahrenheit]
    }
    
    static func unitDescriptionFromIntValue(intValue: Int32) -> String {
        switch intValue {
        case 11: return WaterUnit.oz.description
        case 12: return WaterUnit.ml.description
        case 13: return WaterUnit.g.description
            
        case 21: return WeightUnit.oz.description
        case 22: return WeightUnit.g.description
            
        case 31: return TemperatureUnit.Celsius.description
        case 32: return TemperatureUnit.Fahrenheit.description
            
        default: return ""
        }
    }
}
// swiftlint:enable type_name


// MARK: CustomStringConvertible

extension UnitCategory: CustomStringConvertible {
    var description: String {
        switch self {
            case .Weight: return tr(.UnitCategoryCoffee)
            case .Water: return tr(.UnitCategoryWater)
            case .Temperature: return tr(.UnitCategoryTemperature)
        }
    }
}

// MARK: Water

extension UnitCategory.WaterUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .ml: return "ml"
            case .g: return "g"
        }
    }
}

// MARK: Weight

extension UnitCategory.WeightUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .oz: return "oz"
            case .g: return "g"
        }
    }
}

// MARK: Temperature

extension UnitCategory.TemperatureUnit: CustomStringConvertible {
    var description: String {
        switch self {
            case .Celsius: return "°C"
            case .Fahrenheit: return "°F"
        }
    }
}
