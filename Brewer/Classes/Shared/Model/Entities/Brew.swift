//
//  Brew.swift
//  Brewer
//
//  Created by Maciej Oczko on 16.01.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

class Brew: NSManagedObject {

	func brewAttributesArray() -> [BrewAttribute] {
		guard let attributes = brewAttributes else {
			return []
		}
		return attributes.allObjects as! [BrewAttribute]
	}

	func brewAttributeForType(type: BrewAttributeType) -> BrewAttribute? {
		guard let attributes = brewAttributes where !attributes.isEmpty else {
			return nil
		}
		return attributes
			.filter { ($0 as! BrewAttribute).type == type.intValue }
			.last as? BrewAttribute
	}

	func cuppingAttributeForType(type: CuppingAttribute) -> Cupping? {
		guard let attributes = cuppingAttributes where !attributes.isEmpty else {
			return nil
		}
		return attributes
			.filter { ($0 as! Cupping).type == type.rawValue }
			.last as? Cupping
	}
}

extension Brew: Entity {
	static func entityName() -> String {
		return "Brew"
	}
}
