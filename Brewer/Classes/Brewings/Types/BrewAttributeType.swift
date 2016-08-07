//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum BrewAttributeType: String {
	case Time
	case GrindSize
	case CoffeeWeight
	case WaterWeight
	case WaterTemperature
	case TampStrength
	case Notes

	static let allValues = [Time, GrindSize, CoffeeWeight, WaterWeight, WaterTemperature, TampStrength, Notes]
}

extension BrewAttributeType {
	var segueIdentifier: SegueIdentifier {
		switch self {
		case .Time: return .NumericalInput
		case .GrindSize: return .GrindSize
		case .CoffeeWeight: return .NumericalInput
		case .WaterWeight: return .NumericalInput
		case .WaterTemperature: return .NumericalInput
		case .TampStrength: return .Tamping
		case .Notes: return .Notes
		}
	}
}

extension BrewAttributeType {
	func format(value: Double, withUnitType unit: Int32) -> String {
		switch self {
		case .Time:
			let formatter = NSDateComponentsFormatter()
			formatter.unitsStyle = .Abbreviated
			let components = NSDateComponents()
			components.second = Int(value) % 60
			components.minute = Int(value / 60)
			return formatter.stringFromDateComponents(components) ?? ""
		case .CoffeeWeight, .WaterWeight:
			return "\(value) \(UnitCategory.unitDescriptionFromIntValue(unit))"
        case .WaterTemperature:
            return value.format(".0") + " " + UnitCategory.unitDescriptionFromIntValue(unit)
		case .GrindSize:
            switch GrindSizeUnit(rawValue: unit)! {
            case .Slider:
                return GrindSizeSliderValue(rawValue: value)?.description ?? ""
            case .Numeric:
                return Double(value).format(".1")
            }
		case .TampStrength: return value.format(".1")
		default: fatalError("Unsupported format for brew attribute!")
		}
	}
}

extension BrewAttributeType: CustomStringConvertible {
	var description: String {
		switch self {
		case .Time: return tr(.AttributeTime)
		case .GrindSize: return tr(.AttributeGrindSize)
		case .CoffeeWeight: return tr(.AttributeCoffeeWeight)
		case .WaterWeight: return tr(.AttributeWaterWeight)
		case .WaterTemperature: return tr(.AttributeTemperature)
		case .TampStrength: return tr(.AttributeTampStrength)
		case .Notes: return tr(.AttributeNotes)
		}
	}
}

extension BrewAttributeType {
    var imageName: Asset {
		switch self {
		case .Time: return .Ic_time
		case .GrindSize: return .Ic_grind
		case .CoffeeWeight: return .Ic_weight
		case .WaterWeight: return .Ic_water
		case .WaterTemperature: return .Ic_temp
		case .TampStrength: return .Ic_tamp
		case .Notes: return .Ic_notes
		}
    }
}

extension BrewAttributeType {
	func storyboardIdentifier() -> String {
		switch self {
		case .Time: return "NumericalInput"
		case .GrindSize: return "GrindSize"
		case .CoffeeWeight: return "NumericalInput"
		case .WaterWeight: return "NumericalInput"
		case .WaterTemperature: return "NumericalInput"
		case .TampStrength: return "Tamping"
		case .Notes: return "Notes"
		}
	}
}
