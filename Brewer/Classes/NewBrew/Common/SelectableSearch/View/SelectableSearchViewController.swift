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
	fileprivate let disposeBag = DisposeBag()

	fileprivate lazy var selectableSearchView = SelectableSearchView()

	fileprivate var inputTextField: UITextField {
		return selectableSearchView.inputTextField
	}
	fileprivate var tableView: UITableView {
		return selectableSearchView.tableView
	}

	var active: Bool = false {
		didSet {
			if isViewLoaded {
				selectableSearchView.inputTextField.active = active
                if !active {
                    self.viewModel.addNewSearchItemIfNeeded(self.inputTextField.text)
                }
			}
		}
	}

	let viewModel: SelectableSearchViewModelType
	var themeConfiguration: ThemeConfiguration?

	init(viewModel: SelectableSearchViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
		self.viewModel = viewModel
		self.themeConfiguration = themeConfiguration
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = selectableSearchView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		inputTextField.placeholder = viewModel.placeholder
		tableView.delegate = self
		viewModel.configure(with: tableView)
		inputTextField
            .rx.text
            .asDriver()
            .distinctUntilChanged(==)
            .skip(1)
            .drive(onNext: viewModel.setSearchString)
            .addDisposableTo(disposeBag)
		setupDefaultBackBarButtonItemIfNeeded()
		enableSwipeToBack()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		selectableSearchView.configure(with: themeConfiguration)
	}
}

extension SelectableSearchViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
		(cell as? SelectableSearchResultViewCell)?.configure(with: themeConfiguration)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectItemAtIndexPath(indexPath)
		inputTextField.text = nil
	}
}
