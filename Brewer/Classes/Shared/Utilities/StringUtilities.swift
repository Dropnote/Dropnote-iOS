//
// Created by Maciej Oczko on 30.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation

extension String {
	var capitalizingFirstLetter: String {
		let first = String(characters.prefix(1)).capitalized
		let other = String(characters.dropFirst())
		return first + other
	}

	var lowercasedFirstLetter: String {
		let first = String(characters.prefix(1)).lowercased()
		let other = String(characters.dropFirst())
		return first + other
	}

	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter
	}

	mutating func lowercaseFirstLetter() {
		self = self.lowercasedFirstLetter
	}
}
