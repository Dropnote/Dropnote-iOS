//
//  BrewAttribute.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class BrewAttribute: NSManagedObject {

}

extension BrewAttributeType {
	var intValue: Int32 {
		switch self {
			case .time: return 1
			case .grindSize: return 2
			case .coffeeWeight: return 3
			case .waterWeight: return 4
			case .waterTemperature: return 5
			case .tampStrength: return 6
			case .notes: return 7
			case .preInfusionTime: return 8
		}
	}

	static func fromIntValue(_ intValue: Int32) -> BrewAttributeType {
		switch intValue {
			case 1: return .time
			case 2: return .grindSize
			case 3: return .coffeeWeight
			case 4: return .waterWeight
			case 5: return .waterTemperature
			case 6: return .tampStrength
			case 7: return .notes
			case 8: return .preInfusionTime
			default: fatalError("Wrong brew attribute int code.")
		}
	}
}

extension BrewAttribute: Entity {
	static func entityName() -> String {
		return "BrewAttribute"
	}
}
