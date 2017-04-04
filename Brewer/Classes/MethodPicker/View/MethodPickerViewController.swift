//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension MethodPickerViewController: ThemeConfigurationContainer { }

final class MethodPickerViewController: UIViewController, ThemeConfigurable {
	fileprivate var tableView: UITableView {
		return view as! UITableView
	}

	var themeConfiguration: ThemeConfiguration?
	let viewModel: MethodPickerViewModelType
	let didSelectBrewMethodSubject = PublishSubject<BrewMethod>()

	init(viewModel: MethodPickerViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
		self.viewModel = viewModel
		self.themeConfiguration = themeConfiguration
		super.init(nibName: nil, bundle: nil)
        title = tr(.methodPickItemTitle)
	}

    required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
    }

	override func loadView() {
		view = UITableView(frame: .zero, style: .plain)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        		
		tableView.tableFooterView = UIView()
		tableView.delegate = self
        tableView.rowHeight = 90
		viewModel.configureWithTableView(tableView)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
	}
}

extension MethodPickerViewController: TabBarConfigurable {
    
    func setupTabBar() {
        guard let navigationController = navigationController else { return }
        navigationController.tabBarItem = UITabBarItem(title: tr(.methodPickItemTitle),
                                                       image: UIImage(asset: .Ic_tab_start)?.alwaysOriginal(),
                                                       selectedImage: UIImage(asset: .Ic_tab_start_pressed)?.alwaysOriginal())
        guard let themeConfiguration = themeConfiguration else { return }
        configureTabBarItem(navigationController.tabBarItem, theme: themeConfiguration)
    }
}

extension MethodPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
    
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? MethodPickerCell)?.configureWithTheme(themeConfiguration)
	}
    
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectBrewMethodSubject.onNext(viewModel.methodForIndexPath(indexPath))
	}
}
