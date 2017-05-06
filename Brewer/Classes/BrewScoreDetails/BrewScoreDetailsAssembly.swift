//
//  BrewScoreDetailsAssembly.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewScoreDetailsAssembly: AssemblyType {
    func assemble(container: Container) {        
        container.register(BrewScoreDetailsViewController.self) {
            (r, brew: Brew) in
            BrewScoreDetailsViewController(viewModel: r.resolve(BrewScoreDetailsViewModelType.self, argument: brew)!,
                                           themeConfiguration: r.resolve(ThemeConfiguration.self))
        }
        
        container.register(BrewScoreDetailsViewModelType.self) {
            (_, brew: Brew) in BrewScoreDetailsViewModel(brew: brew)
        }
    }
}
