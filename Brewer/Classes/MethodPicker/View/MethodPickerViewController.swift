//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension MethodPickerViewController: ThemeConfigurationContainer { }

final class MethodPickerViewController: UIViewController, ThemeConfigurable {
    
	@IBOutlet weak var tableView: UITableView!

	var themeConfiguration: ThemeConfiguration?
	var viewModel: MethodPickerViewModelType!
	let didSelectBrewMethodSubject = PublishSubject<BrewMethod>()

	override func viewDidLoad() {
		super.viewDidLoad()
        title = tr(.MethodPickItemTitle)
		
		tableView.tableFooterView = UIView()
		tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
		viewModel.configureWithTableView(tableView)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if case .SequenceSettings = segueIdentifierForSegue(segue) {
			if let viewController = segue.destinationViewController as? SequenceSettingsViewController {
				viewController.brewMethod = BrewMethod(rawValue: sender as! String)!
			}
		}
	}
}

extension MethodPickerViewController: TabBarConfigurable {
    
    func setupTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.tabBarItem = UITabBarItem(title: tr(.MethodPickItemTitle),
                                                       image: UIImage(asset: .Ic_tab_start)?.alwaysOriginal(),
                                                       selectedImage: UIImage(asset: .Ic_tab_start_pressed)?.alwaysOriginal())
        guard let themeConfiguration = themeConfiguration else { return }
        configureTabBarItem(navigationController.tabBarItem, theme: themeConfiguration)
    }
}

extension MethodPickerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = true
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
    }
    
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as? MethodPickerCell)?.configureWithTheme(themeConfiguration)
	}
    
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		didSelectBrewMethodSubject.onNext(viewModel.methodForIndexPath(indexPath))
	}
}
