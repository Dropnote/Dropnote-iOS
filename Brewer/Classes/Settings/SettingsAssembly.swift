//
// Created by Maciej Oczko on 21.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

final class SettingsAssembly: AssemblyType {
    func assemble(container: Container) {

        // MARK: Main

        container.register(SettingsViewController.self) {
            r in
            SettingsViewController(viewModel: r.resolve(SettingsViewModel.self)!,
                                   themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(SettingsViewModel.self) {
            _ in SettingsViewModel()
        }

        // MARK: Method picker

        container.register(MethodPickerViewController.self) {
            r in
            MethodPickerViewController(viewModel: r.resolve(MethodPickerViewModelType.self)!,
                                       themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(MethodPickerViewModelType.self) {
            _ in MethodPickerViewModel()
        }

        // MARK: Sequence

        container.register(SequenceSettingsViewController.self) {
            (r, brewMethod: BrewMethod) in
            SequenceSettingsViewController(viewModel: r.resolve(SequenceSettingsViewModelType.self, argument: brewMethod)!,
                                           themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(SequenceSettingsViewModelType.self) {
            r, brewMethod in
            SequenceSettingsViewModel(
                    brewMethod: brewMethod,
                    modelController: r.resolve(SequenceSettingsModelControllerType.self)!
            )
        }

        container.register(SequenceSettingsModelControllerType.self) {
            r in
            SequenceSettingsModelController(store: r.resolve(KeyValueStoreType.self)!)
        }

        // MARK: Units

        container.register(UnitsViewController.self) {
            r in
            UnitsViewController(viewModel: r.resolve(UnitsViewModelType.self)!,
                                themeConfiguration: r.resolve(ThemeConfiguration.self))
        }

        container.register(UnitsViewModelType.self) {
            r in UnitsViewModel(modelController: r.resolve(UnitsModelControllerType.self)!, dataSourcesFactory: r.resolve(UnitsDataSourcesFactoryType.self)!)
        }

        container.register(UnitsDataSourcesFactoryType.self) {
            _ in UnitsDataSourcesFactory()
        }

        container.register(UnitsModelControllerType.self) {
            r in UnitsModelController(store: r.resolve(KeyValueStoreType.self)!)
        }
        
        // MARK: About
        
        container.registerForStoryboard(AboutViewController.self) {
            r, c in
            c.themeConfiguration = r.resolve(ThemeConfiguration.self)
        }
    }
}

extension UserDefaults: KeyValueStoreType {

}
