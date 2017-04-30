//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum BrewAttributeType: String {
	case preInfusionTime
	case time
	case grindSize
	case coffeeWeight
	case waterWeight
	case waterTemperature
	case tampStrength
	case notes

	static let allValues = [preInfusionTime, time, grindSize, coffeeWeight, waterWeight, waterTemperature, tampStrength, notes]

	// It's necessary after migrating to swift 3 naming guidelines (first letter lower case)
	public init?(rawValue: String) {
		let lowerFirstValue = rawValue.lowercasedFirstLetter
		switch lowerFirstValue {
			case "preInfusionTime": self = .preInfusionTime
			case "time": self = .time
			case "grindSize": self = .grindSize
			case "coffeeWeight": self = .coffeeWeight
			case "waterWeight": self = .waterWeight
			case "waterTemperature": self = .waterTemperature
			case "tampStrength": self = .tampStrength
			case "notes": self = .notes
			default: return nil
		}
	}
}

extension BrewAttributeType {
	func format(_ value: Double, withUnitType unit: Int32) -> String {
		switch self {
			case .time, .preInfusionTime:
				let formatter = DateComponentsFormatter()
				formatter.unitsStyle = .abbreviated
				var components = DateComponents()
				components.second = Int(value) % 60
				components.minute = Int(value / 60)
				return formatter.string(from: components) ?? ""
			case .coffeeWeight, .waterWeight:
				return "\(value) \(UnitCategory.unitDescriptionFromIntValue(unit))"
			case .waterTemperature:
				return value.format(".0") + " " + UnitCategory.unitDescriptionFromIntValue(unit)
			case .grindSize:
				switch GrindSizeUnit(rawValue: unit)! {
					case .slider:
						return GrindSizeSliderValue(rawValue: value)?.description ?? ""
					case .numeric:
						return Double(value).format(".1")
				}
			case .tampStrength: return value.format(".1")
			default: fatalError("Unsupported format for brew attribute!")
		}
	}
}

extension BrewAttributeType: CustomStringConvertible {
	var description: String {
		switch self {
			case .preInfusionTime: return tr(.attributePreInfusionTime)
			case .time: return tr(.attributeTime)
			case .grindSize: return tr(.attributeGrindSize)
			case .coffeeWeight: return tr(.attributeCoffeeWeight)
			case .waterWeight: return tr(.attributeWaterWeight)
			case .waterTemperature: return tr(.attributeTemperature)
			case .tampStrength: return tr(.attributeTampStrength)
			case .notes: return tr(.attributeNotes)
		}
	}
}

extension BrewAttributeType {
	var imageName: Asset {
		switch self {
			case .time: return .Ic_time
			case .preInfusionTime: return .Ic_time
			case .grindSize: return .Ic_grind
			case .coffeeWeight: return .Ic_weight
			case .waterWeight: return .Ic_water
			case .waterTemperature: return .Ic_temp
			case .tampStrength: return .Ic_tamp
			case .notes: return .Ic_notes
		}
	}
}
