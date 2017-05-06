//
//  RootViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import RxSwift
import RxCocoa

extension RootViewController: ThemeConfigurationContainer { }
extension RootViewController: ResolvableContainer { }

final class RootViewController: UITabBarController {
    let resolver: ResolverType
	var themeConfiguration: ThemeConfiguration?

    fileprivate let contentViewControllers: [UIViewController]
    
    var brewingsViewController: BrewingsViewController? {
        return contentViewControllers.elements(ofType: BrewingsViewController.self).first
    }
    
    init(viewControllers: [UIViewController], themeConfiguration: ThemeConfiguration? = nil, resolver: ResolverType = Assembler.sharedResolver) {
        self.contentViewControllers = viewControllers
        self.themeConfiguration = themeConfiguration
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        
        viewControllers = contentViewControllers.map { UINavigationController(rootViewController: $0) }

        let methodPickerViewController = contentViewControllers
            .elements(ofType: MethodPickerViewController.self)
            .first
        
        _ = methodPickerViewController?
            .didSelectBrewMethodSubject
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                brewMethod in
                Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.newBrew, method: brewMethod)
                self.showNewBrewVieController(for: brewMethod)
            })
        
        contentViewControllers
            .elements(ofType: TabBarConfigurable.self)
            .forEach { $0.setupTabBar() }

        configureWithTheme(themeConfiguration)
	}
    
    private func dismissNewBrewViewController(_ switchToHistory: Bool) {
        if let historyViewControllerIndex = contentViewControllers.index(where: { $0 is BrewingsViewController }) , switchToHistory == true {
            selectedIndex = historyViewControllerIndex
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showNewBrewVieController(for brewMethod: BrewMethod) {
        let brewContext = StartBrewContext(method: brewMethod)
        let newBrewViewController = resolver.resolve(NewBrewViewController.self, argument: brewContext)!
        _ = newBrewViewController
                .hideViewControllerSwitchingToHistorySubject
                .subscribe(onNext: dismissNewBrewViewController)
        let navigatationController = UINavigationController(rootViewController: newBrewViewController)
        present(navigatationController, animated: true, completion: nil)
    }
}

extension RootViewController: ThemeConfigurable {

	func configureWithTheme(_ theme: ThemeConfiguration?) {
		guard let theme = theme else { return }

		tabBar.tintColor = theme.tabBarConfiguration.tintColor
		tabBar.barTintColor = theme.tabBarConfiguration.barTintColor
		tabBar.isTranslucent = theme.tabBarConfiguration.translucent
        tabBar.items?[0].accessibilityLabel = "Select First"
        tabBar.items?[0].accessibilityHint = "Selects Starting New Brew Tab"
        tabBar.items?[1].accessibilityLabel = "Select Second"
        tabBar.items?[1].accessibilityHint = "Selects History Tab"
        tabBar.items?[2].accessibilityLabel = "Select Third"
        tabBar.items?[2].accessibilityHint = "Selects Settigns Tab"

		contentViewControllers
            .elements(ofType: ThemeConfigurable.self)			
            .forEach { $0.configure(with: themeConfiguration) }
	}
}
