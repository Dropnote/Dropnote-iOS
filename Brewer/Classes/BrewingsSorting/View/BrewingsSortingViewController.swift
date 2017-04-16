//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension BrewingsSortingViewController: ThemeConfigurable { }
extension BrewingsSortingViewController: ThemeConfigurationContainer { }

final class BrewingsSortingViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

    var themeConfiguration: ThemeConfiguration?
    let viewModel: BrewingsSortingViewModelType

    let dismissViewControllerAnimatedSubject = PublishSubject<Bool>()
    let switchSortingOptionSubject = PublishSubject<BrewingSortingOption>()

    init(viewModel: BrewingsSortingViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.brewingsSortingSortTitle)
        viewModel.configure(with: tableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_close), style: .plain, target: self, action: #selector(close))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure(with: themeConfiguration)
        tableView.configure(with: themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewingSort)
    }

    func close() {
        dismissViewControllerAnimatedSubject.onNext(true)
    }
}

extension BrewingsSortingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? BrewingsSortingOptionCell)?.configure(with: themeConfiguration)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        viewModel.selectSortingOptionAtIndexPath(indexPath)
        for cell in tableView.visibleCells {
            if cell == currentCell {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }

        _ = MainScheduler
            .asyncInstance
            .scheduleRelative(viewModel.sortingOption, dueTime: 0.2) {
                [weak self] sortingOption in
                guard let `self` = self else { return Disposables.create() }
                self.switchSortingOptionSubject.onNext(sortingOption)
                self.dismissViewControllerAnimatedSubject.onNext(true)
                return BooleanDisposable(isDisposed: true)
        }
    }
}
