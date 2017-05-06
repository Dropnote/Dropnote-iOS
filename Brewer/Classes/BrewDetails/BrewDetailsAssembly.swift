//
//  BrewDetailsAssembly.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class BrewDetailsAssembly: AssemblyType {
	func assemble(container: Container) {
        
        container.register(BrewDetailsViewController.self) {
			(r, brew: Brew, editable: Bool) in
			BrewDetailsViewController(viewModel: r.resolve(BrewDetailsViewModelType.self, arguments: brew, editable)!,
									  themeConfiguration: r.resolve(ThemeConfiguration.self))
		}

		container.register(BrewDetailsViewModelType.self) {
			(r, brew: Brew, editable: Bool) in
			BrewDetailsViewModel(editable: editable,
								 brewModelController: r.resolve(BrewModelControllerType.self, argument: brew)!,
								 spotlightSearchService: r.resolve(SpotlightSearchService.self)!)
		}
	}
}
