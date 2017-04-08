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

    private func loadCoffeeSectionViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
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

    private func loadAttributesViewControllers(_ brewContext: StartBrewContext) -> [UIViewController] {
        let factory = NewBrewViewControllersFactory(resolver: resolver, brewModelController: brewModelController)
        let sequence = settingsModelController
            .sequenceSteps(for: brewContext.method, filter: .active)
            .map { $0.type! }
        print(sequence)
        sequence.forEach { progressIcons.append($0.imageName) }
        return sequence.map(factory.createViewController(for:))
    }

    private func loadSummaryViewControllers() -> [UIViewController] {
        guard let brew = brewModelController.currentBrew() else { fatalError("No current brew available") }
        let editable = false
        let brewDetailsViewController = resolver.resolve(BrewDetailsViewController.self, arguments: brew, editable)!
        return [brewDetailsViewController]
    }
}
