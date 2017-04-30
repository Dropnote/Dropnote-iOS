//
// Created by Maciej Oczko on 24.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

enum BrewMethod: String {
	case coffeeMachine
	case pourOverV60
	case pourOverChemex
	case aeropressTraditional
	case aeropressInverted
	case kone
	case kalita

	static let allValues = [coffeeMachine, pourOverV60, pourOverChemex, aeropressTraditional, aeropressInverted, kone, kalita]

	// It's necessary after migrating to swift 3 naming guidelines (first letter lower case)
	init?(serializableValue: String) {
		if let method = BrewMethod(rawValue: serializableValue) {
			self = method
		} else if let method = BrewMethod(rawValue: serializableValue.lowercasedFirstLetter) {
			self = method
		} else if let method = BrewMethod(rawValue: serializableValue.capitalizingFirstLetter) {
			self = method
		} else {
			return nil
		}
	}

	var serializableValue: String {
		return rawValue.capitalizingFirstLetter
	}
}

extension BrewMethod: CustomStringConvertible {
	var description: String {
		switch self {
			case .coffeeMachine, .kone, .kalita: return ""
			case .pourOverV60: return tr(.methodDetailV60)
			case .pourOverChemex: return tr(.methodDetailChemex)
			case .aeropressTraditional: return tr(.methodDetailTraditional)
			case .aeropressInverted: return tr(.methodDetailInverted)
		}
	}
}

extension BrewMethod {
	var categoryDescription: String {
		switch self {
			case .coffeeMachine: return tr(.methodEsspressoMachine)
			case .pourOverV60: return tr(.methodPourOver)
			case .pourOverChemex: return tr(.methodPourOver)
			case .aeropressTraditional: return tr(.methodAeropress)
			case .aeropressInverted: return tr(.methodAeropress)
			case .kone: return tr(.methodKone)
			case .kalita: return tr(.methodKalita)
		}
	}
}

extension BrewMethod {
	var imageName: Asset {
		switch self {
			case .coffeeMachine: return .Ic_coffee_machine
			case .pourOverV60: return .Ic_drip
			case .pourOverChemex: return .Ic_chemex
			case .aeropressTraditional: return .Ic_aeropress
			case .aeropressInverted: return .Ic_inverted
			case .kone: return .Ic_kone
			case .kalita: return .Ic_kalita
		}
	}
}

extension BrewMethod {
	var color: UIColor {
		switch self {
			case .coffeeMachine: return .dullLavender()
			case .pourOverV60: return .deepBlush()
			case .pourOverChemex: return .rajah()
			case .aeropressTraditional: return .pearlAqua()
			case .aeropressInverted: return .lightSkyBlue()
			case .kone: return .geraldine()
			case .kalita: return .feijoa()
		}
	}

	var lightColor: UIColor {
		switch self {
			case .coffeeMachine: return .moonRaker()
			case .pourOverV60: return .shocking()
			case .pourOverChemex: return .gold()
			case .aeropressTraditional: return .scandal()
			case .aeropressInverted: return .sail()
			case .kone: return .sundown()
			case .kalita: return .sprout()
		}
	}
}

extension BrewMethod {
	var intValue: Int32 {
		switch self {
			case .coffeeMachine: return 0
			case .pourOverV60: return 1
			case .pourOverChemex: return 2
			case .aeropressTraditional: return 3
			case .aeropressInverted: return 4
			case .kone: return 5
			case .kalita: return 6
		}
	}

	static func fromIntValue(_ intValue: Int32) -> BrewMethod {
		switch intValue {
			case 0: return coffeeMachine
			case 1: return pourOverV60
			case 2: return pourOverChemex
			case 3: return aeropressTraditional
			case 4: return aeropressInverted
			case 5: return kone
			case 6: return kalita
			default: fatalError("Wrong brew method int value!")
		}
	}
}

extension BrewMethod {

	static func fromQuickType(string: String) -> BrewMethod {
		switch string {
			case "pl.maciejoczko.Dropnote.traditional": return .aeropressTraditional
			case "pl.maciejoczko.Dropnote.inverted": return .aeropressInverted
			case "pl.maciejoczko.Dropnote.v60": return .pourOverV60
			case "pl.maciejoczko.Dropnote.chemex": return .pourOverChemex
			case "pl.maciejoczko.Dropnote.coffeemachine": return .coffeeMachine
			case "pl.maciejoczko.Dropnote.kone": return .kone
			case "pl.maciejoczko.Dropnote.kalita": return .kalita
			default: fatalError("Wrong brew method quick type value!")
		}
	}
}

extension BrewMethod: TitleImagePresentable {
	var title: String {
		let ending = description.isEmpty ? "" : " " + description
		return categoryDescription + ending
	}

	var image: UIImage {
		return UIImage(asset: imageName)!
	}
}
