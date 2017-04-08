//
// Created by Maciej Oczko on 02.08.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

final class NewBrewDataSource {
    fileprivate(set) var progressIcons: [Asset] = []
    fileprivate(set) var stepViewControllers: [[UIViewController]] = []

    let brewContext: StartBrewContext
    let brewModelController: BrewModelControllerType
    let settingsModelController: SequenceSettingsModelControllerType
    let resolver: ResolverType

    init(brewContext: StartBrewContext,
         brewModelController: BrewModelControllerType,
         settingsModelController: SequenceSettingsModelControllerType,
         resolver: ResolverType = Assembler.sharedResolver) {
        self.brewContext = brewContext
        self.brewModelController = brewModelController
        self.settingsModelController = settingsModelController
        self.resolver = resolver
    }

    func reloadData() {
        progressIcons.removeAll()
        stepViewControllers.removeAll()
        stepViewControllers.append(loadCoffeeSectionViewControllers(brewContext))
        stepViewControllers.append(loadAttributesViewControllers(brewContext))
        stepViewControllers.append(loadSummaryViewControllers())
    }

    fileprivate func loadCoffeeSectionViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
        func instantiateViewController(withIdentifier identifier: SelectableSearchIdentifier, model: BrewModelControllerType) -> SelectableSearchViewController {
            let viewController = resolver.resolve(SelectableSearchViewController.self, arguments: identifier, model)!
            viewController.title = identifier.description
            return viewController
        }

        var viewControllers = [UIViewController]()
        if brewContext.method == .coffeeMachine {
            viewControllers.append(instantiateViewController(withIdentifier: .coffeeMachine, model: brewModelController))
            progressIcons.append(.Ic_machine)
        }
        viewControllers.append(instantiateViewController(withIdentifier: .coffee, model: brewModelController))
        progressIcons.append(.Ic_coffee)
        return viewControllers
    }

    fileprivate func loadAttributesViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
        let sequence = settingsModelController
            .sequenceSteps(for: brewContext.method, filter: .active)
            .map { $0.type! }
        print(sequence)
        return sequence.map {
            progressIcons.append($0.imageName)

            // TODO refactor when all types are changed
            if $0.storyboardIdentifier() == "NumericalInput" {
                let numericalInputViewController = resolver.resolve(NumericalInputViewController.self,
                                                                    arguments: $0, brewModelController)!
                numericalInputViewController.title = $0.description
                return numericalInputViewController
            }
            if $0.storyboardIdentifier() == "Notes" {
                let notesViewController = resolver.resolve(NotesViewController.self, argument: brewModelController)!
                notesViewController.title = $0.description
                return notesViewController
            }
            if $0.storyboardIdentifier() == "Tamping" {
                let tampingViewController = resolver.resolve(TampingViewController.self, argument: brewModelController)!
                tampingViewController.title = $0.description
                return tampingViewController
            }

            let viewController = resolver.viewControllerForIdentifier($0.storyboardIdentifier())
            viewController.title = $0.description

            if viewController is GrindSizeViewController {
                let grindSizeViewModel = resolver.resolve(GrindSizeViewModelType.self, argument: brewModelController)!
                (viewController as! GrindSizeViewController).viewModel = grindSizeViewModel
            }

            return viewController
        }
    }

    fileprivate func loadSummaryViewControllers() -> [UIViewController] {
        guard let brew = brewModelController.currentBrew() else { fatalError("No current brew available") }
        let editable = false
        let brewDetailsViewController = resolver.resolve(BrewDetailsViewController.self, arguments: brew, editable)!
        return [brewDetailsViewController]
    }
}
