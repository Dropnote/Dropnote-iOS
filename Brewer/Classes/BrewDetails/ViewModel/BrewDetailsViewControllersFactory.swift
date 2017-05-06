//
// Created by Maciej Oczko on 08.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

final class BrewDetailsViewControllersFactory {
	let resolver: ResolverType
	let viewModel: BrewDetailsViewModelType

	init(resolver: ResolverType, viewModel: BrewDetailsViewModelType) {
		self.resolver = resolver
		self.viewModel = viewModel
	}

	func createViewController(for sectionType: BrewDetailsTableViewSection, at indexPath: IndexPath) -> UIViewController? {
		switch sectionType {
			case .score:
				return resolver.resolve(BrewScoreDetailsViewController.self, argument: viewModel.currentBrew())!
			case .attributes:
				guard viewModel.isEditable else { return nil }
				let brewAttributeType = viewModel.brewAttributeType(forIndexPath: indexPath)
				let newBrewViewControllersFactory = NewBrewViewControllersFactory(resolver: resolver,
																				  brewModelController: viewModel.brewModelController)
				return newBrewViewControllersFactory.createViewController(for: brewAttributeType)
			case .notes:
				return resolver.resolve(NotesViewController.self, argument: viewModel.brewModelController)!
			case .coffeeInfo:
				guard viewModel.isEditable else { return nil }
				let searchIdentifier = viewModel.coffeeAttribute(forIndexPath: indexPath)
				let viewController = resolver.resolve(SelectableSearchViewController.self,
													  arguments: searchIdentifier, viewModel.brewModelController)!
				viewController.title = searchIdentifier.description
				return viewController
			case .remove:
				fatalError("Invalid section type for view controller creation!")
		}
	}
}
