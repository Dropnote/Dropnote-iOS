//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

extension BrewAttributeType {
	func defaultPosition(forMethod method: BrewMethod) -> Int {
		switch self {
			case .coffeeWeight: return 0
			case .grindSize: return 1
			case .tampStrength: return 2
			case .waterTemperature: return 3
			case .waterWeight: return 4
			case .preInfusionTime: return 5
			case .time: return 6
			case .notes: return 7
		}
	}

	func defaultEnabled(forMethod method: BrewMethod) -> Bool {
		switch self {
			case .coffeeWeight, .grindSize, .waterTemperature, .waterWeight, .time, .notes:
				return true
			case .preInfusionTime:
				return false
			case .tampStrength:
				switch method {
					case .coffeeMachine: return true
					default: return false
				}
		}
	}
}
