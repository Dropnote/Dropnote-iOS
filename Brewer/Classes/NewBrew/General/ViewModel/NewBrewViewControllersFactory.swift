//
// Created by Maciej Oczko on 08.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

final class NewBrewViewControllersFactory {
	let resolver: ResolverType
	let brewModelController: BrewModelControllerType

	init(resolver: ResolverType, brewModelController: BrewModelControllerType) {
		self.resolver = resolver
		self.brewModelController = brewModelController
	}

	func createViewController(for attribute: BrewAttributeType) -> UIViewController {
		let viewController: UIViewController
		switch attribute {
			case .time, .preInfusionTime, .coffeeWeight, .waterWeight, .waterTemperature:
				viewController = resolver.resolve(NumericalInputViewController.self, arguments: attribute, brewModelController)!
				break
			case .grindSize:
				viewController = resolver.resolve(GrindSizeViewController.self, argument: brewModelController)!
				break
			case .tampStrength:
				viewController = resolver.resolve(TampingViewController.self, argument: brewModelController)!
				break
			case .notes:
				viewController = resolver.resolve(NotesViewController.self, argument: brewModelController)!
				break
		}
		viewController.title = attribute.description
		return viewController
	}

}
