//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

// swiftlint:disable function_body_length
final class NewBrewAssembly: AssemblyType {
	func assemble(_ container: Container) {

		// MARK: New Brew container

		container.registerForStoryboard(NewBrewViewController.self) {
			r, c in
			c.metrics = r.resolve(ScrollViewPageMetricsType.self)!
			c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NewBrewViewModelType.self) {
			(r, context: StartBrewContext) in
			let viewModel = NewBrewViewModel(brewContext: context,
											 settingsModelController: r.resolve(SequenceSettingsModelControllerType.self)!,
											 newBrewModelController: r.resolve(BrewModelControllerType.self)!)
			viewModel.resolver = r
			return viewModel
		}

		container.register(BrewModelControllerType.self) {
			r in BrewModelController(stack: r.resolve(StackType.self)!)
		}

		container.register(BrewModelControllerType.self) {
			(r, brew: Brew) in BrewModelController(stack: r.resolve(StackType.self)!, brew: brew)
		}

		container.register(ScrollViewPageMetricsType.self) {
			r in ScrollViewPageMetrics()
		}

		// MARK: Selectable search

		container.registerForStoryboard(SelectableSearchViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(SelectableSearchViewModelType.self) {
			(r, identifier: SelectableSearchIdentifier, brewModelController: BrewModelControllerType) in
			return SelectableSearchViewModel(modelController:
					r.resolve(SelectableSearchModelControllerType.self, arguments: (identifier, brewModelController))!
			)
		}

		container.register(SelectableSearchModelControllerType.self) {
			(r, identifier: SelectableSearchIdentifier, brewModelController: BrewModelControllerType) in

			switch identifier {
			case .Coffee: return r.resolve(CoffeeSelectableSearchModelController.self, argument: brewModelController)!
			case .CoffeeMachine: return r.resolve(CoffeeMachineSelectableSearchModelController.self, argument: brewModelController)!
			}
		}

		// MARK: Coffee & CoffeeMachine

		container.register(CoffeeSelectableSearchModelController.self) {
			r, brewModelController in CoffeeSelectableSearchModelController(stack: r.resolve(StackType.self)!, brewModelController: brewModelController)
		}

		container.register(CoffeeMachineSelectableSearchModelController.self) {
			r, brewModelController in CoffeeMachineSelectableSearchModelController(stack: r.resolve(StackType.self)!, brewModelController: brewModelController)
		}

		// MARK: Numerical input

		container.registerForStoryboard(NumericalInputViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NumericalInputViewModelType.self) {
			(r, attribute: BrewAttributeType, brewModelContorller: BrewModelControllerType) in
			switch attribute {
			case .Time: return r.resolve(TimeInputViewModel.self, argument: brewModelContorller)!
			case .CoffeeWeight: return r.resolve(WeightInputViewModel.self, argument: brewModelContorller)!
			case .WaterWeight: return r.resolve(WaterInputViewModel.self, argument: brewModelContorller)!
			case .WaterTemperature: return r.resolve(TemperatureInputViewModel.self, argument: brewModelContorller)!
			default: fatalError("Wrong type selected for numeric input!")
			}
		}

		// MARK: Attributes: Weight, Water, Temperature, Time

		container.register(WeightInputViewModel.self) {
			r, brewModelContorller in WeightInputViewModel(unitModelController: r.resolve(UnitsModelControllerType)!, brewModelController: brewModelContorller)
		}

		container.register(WaterInputViewModel.self) {
			r, brewModelContorller in WaterInputViewModel(unitModelController: r.resolve(UnitsModelControllerType)!, brewModelController: brewModelContorller)
		}

		container.register(TemperatureInputViewModel.self) {
			r, brewModelContorller in TemperatureInputViewModel(
                unitModelController: r.resolve(UnitsModelControllerType)!,
                brewModelController: brewModelContorller
            )
		}

		container.register(TimeInputViewModel.self) {
			r, brewModelContorller in TimeInputViewModel(unitModelController: r.resolve(UnitsModelControllerType)!, brewModelController: brewModelContorller)
		}

		// MARK: Notes

		container.registerForStoryboard(NotesViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(NotesViewModelType.self) {
			r, brewModelContorller in NotesViewModel(brewModelController: brewModelContorller)
		}

		// MARK: Grind Size

		container.registerForStoryboard(GrindSizeViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(GringSizeViewModelType.self) {
			r, brewModelContorller in GringSizeViewModel(brewModelController: brewModelContorller,
			                                             keyValueStore: r.resolve(KeyValueStoreType.self)!)
		}

		// MARK: Tamping

		container.registerForStoryboard(TampingViewController.self) {
			r, c in c.themeConfiguration = r.resolve(ThemeConfiguration.self)
		}

		container.register(TampingViewModelType.self) {
			r, brewModelContorller in TampingViewModel(brewModelController: brewModelContorller)
		}
	}
}
// swiftlint:enable function_body_length
