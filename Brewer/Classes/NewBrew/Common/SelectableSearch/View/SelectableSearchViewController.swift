//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension SelectableSearchViewController: Activable { }
extension SelectableSearchViewController: ThemeConfigurationContainer { }

final class SelectableSearchViewController: UIViewController {
	private let disposeBag = DisposeBag()

	var themeConfiguration: ThemeConfiguration?

    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.accessibilityLabel = "Type"
        }
    }
	@IBOutlet weak var tableView: UITableView!
	var viewModel: SelectableSearchViewModelType!

	var active: Bool = false {
		didSet {
			if var responder = inputTextField {
				responder.active = active
			}
            if let inputTextField = inputTextField where !active {
                viewModel.addNewSearchItemIfNeeded(inputTextField.text)
            }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		inputTextField.placeholder = viewModel.placeholder
		tableView.delegate = self
		tableView.tableFooterView = UIView()
		viewModel.configureWithTableView(tableView)
		inputTextField
            .rx_text
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .driveNext(viewModel.setSearchString)
            .addDisposableTo(disposeBag)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		view.configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
		inputTextField.configureWithTheme(themeConfiguration)
	}
}

extension SelectableSearchViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
		cell.configureWithTheme(themeConfiguration)
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		viewModel.selectItemAtIndexPath(indexPath)
		inputTextField.text = nil
	}
}
