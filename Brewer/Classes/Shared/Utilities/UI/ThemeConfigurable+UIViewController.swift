//
//  UIViewController+ThemeConfiguration.swift
//  Brewer
//
//  Created by Maciej Oczko on 02.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UIViewController {

	func configureWithTheme(theme: ThemeConfiguration?) {
		guard let theme = theme else { return }
        configureTabBarItem(tabBarItem, theme: theme)
		configureNavigationBar(theme.navigationBarConfiguration)
		configureBarButtonItems(theme)
        if isViewLoaded() {
            view.configureWithTheme(theme)
        }
	}

    func configureTabBarItem(tabBarItem: UITabBarItem, theme: ThemeConfiguration) {
		theme.tabBarItemConfigurations.forEach {
			state, config in
			tabBarItem.setTitleTextAttributes([
				NSFontAttributeName: config.font,
				NSForegroundColorAttributeName: config.color
				], forState: state)
		}
	}

	private func configureNavigationBar(theme: NavigationBarThemeConfiguration) {
		guard let navigationBar = navigationController?.navigationBar else {
			return
		}
		navigationBar.titleTextAttributes = [
			NSFontAttributeName: theme.titleFont,
			NSForegroundColorAttributeName: theme.titleColor
		]
		navigationBar.translucent = theme.translucent
		navigationBar.barTintColor = theme.barTintColor
		navigationBar.tintColor = theme.tintColor
        
        if let nc = navigationController where nc.viewControllers.first != self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_back), style: .Plain, target: self, action: #selector(pop))
        }
	}

	private func configureBarButtonItems(theme: ThemeConfiguration) {
		[navigationItem.rightBarButtonItems, navigationItem.leftBarButtonItems]
			.flatMap { $0 }
			.flatten()
			.forEach { $0.tintColor = theme.barButtonItemConfiguration.tintColor }
	}
}

extension UIView: ThemeConfigurable { }
extension ThemeConfigurable where Self: UIView {
    func configureWithTheme(theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        tintColor = theme.lightTintColor
    }
}
