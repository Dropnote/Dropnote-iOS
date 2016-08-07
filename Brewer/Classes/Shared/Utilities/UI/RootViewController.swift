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
import Box
import RxSwift
import RxCocoa

extension RootViewController: ThemeConfigurationContainer { }
extension RootViewController: ResolvableContainer { }

final class RootViewController: UITabBarController {
    var resolver: ResolverType?
	var themeConfiguration: ThemeConfiguration?

    private var contentViewControllers: [UIViewController]?

	override func viewDidLoad() {
		super.viewDidLoad()

        contentViewControllers = viewControllers?
            .elements(ofType: UINavigationController.self)
            .map { $0.topViewController }
            .flatMap { $0 }
        
        let methodPickerViewController = contentViewControllers?
            .elements(ofType: MethodPickerViewController.self)
            .first
        
        _ = methodPickerViewController?
            .didSelectBrewMethodSubject
            .observeOn(MainScheduler.asyncInstance)
            .subscribeNext {
                brewMethod in
                Analytics.sharedInstance.trackMethodPickEvent(onScreen: AppScreen.newBrew, method: brewMethod)
                let context = StartBrewContext(method: brewMethod)
                self.performSegue(.StartNewBrew, sender: Box(context))
        }
        
        contentViewControllers?
            .elements(ofType: TabBarConfigurable.self)
            .forEach { $0.setupTabBar() }

        configureWithTheme(themeConfiguration)
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let resolver = resolver else { fatalError("Dependency resolver is missing.") }

        if case .StartNewBrew = segueIdentifierForSegue(segue) where sender is Box<StartBrewContext> {
            let boxedBrewContext = sender as! Box<StartBrewContext>
            let nc = segue.destinationViewController as! UINavigationController
            let newBrewViewController = nc.topViewController as! NewBrewViewController
            newBrewViewController.viewModel = resolver.resolve(NewBrewViewModelType.self, argument: boxedBrewContext.value)!
            _ = newBrewViewController
                .hideViewControllerSwitchingToHistorySubject
                .subscribeNext(dismissNewBrewViewController)
        }

        if let unwindSegue = segue as? NewBrewUnwindSegue where unwindSegue.shouldSwitchToHistory == true {
            if let historyViewControllerIndex = contentViewControllers?.indexOf({ $0 is BrewingsViewController }) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.selectedIndex = historyViewControllerIndex
                }
            }
        }
    }
    
    private func dismissNewBrewViewController(switchToHistory: Bool) {
        if let historyViewControllerIndex = contentViewControllers?.indexOf({ $0 is BrewingsViewController }) where switchToHistory == true {
            selectedIndex = historyViewControllerIndex
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RootViewController: ThemeConfigurable {

	func configureWithTheme(theme: ThemeConfiguration?) {
		guard let theme = theme else { return }

		tabBar.tintColor = theme.tabBarConfiguration.tintColor
		tabBar.barTintColor = theme.tabBarConfiguration.barTintColor
		tabBar.translucent = theme.tabBarConfiguration.translucent
        tabBar.items?[0].accessibilityLabel = "Select First"
        tabBar.items?[0].accessibilityHint = "Selects Starting New Brew Tab"
        tabBar.items?[1].accessibilityLabel = "Select Second"
        tabBar.items?[1].accessibilityHint = "Selects History Tab"
        tabBar.items?[2].accessibilityLabel = "Select Third"
        tabBar.items?[2].accessibilityHint = "Selects Settigns Tab"

		contentViewControllers?
            .elements(ofType: ThemeConfigurable.self)			
			.forEach { $0.configureWithTheme(themeConfiguration) }
	}
}
