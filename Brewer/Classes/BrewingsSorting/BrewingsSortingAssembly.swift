//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewingsSortingAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(BrewingsSortingViewController.self) {
            (r, sortingOption: BrewingSortingOption) in
            BrewingsSortingViewController(viewModel: r.resolve(BrewingsSortingViewModelType.self, argument: sortingOption)!,
                                          themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(BrewingsSortingViewModelType.self) {
            _, sortingOption in return BrewingsSortingViewModel(sortingOption: sortingOption)
        }
    }
}
