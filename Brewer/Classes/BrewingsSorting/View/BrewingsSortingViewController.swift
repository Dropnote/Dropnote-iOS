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
    @IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: BrewingsSortingViewModelType!

    let dismissViewControllerAnimatedSubject = PublishSubject<Bool>()
    let switchSortingOptionSubject = PublishSubject<BrewingSortingOption>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.BrewingsSortingSortTitle)
        
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        viewModel.configureWithTableView(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewingSort)
    }

    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimatedSubject.onNext(true)
    }
}

extension BrewingsSortingViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        (cell as? BrewingsSortingOptionCell)?.configureWithTheme(themeConfiguration)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        viewModel.selectSortingOptionAtIndexPath(indexPath)
        for cell in tableView.visibleCells {
            if cell == currentCell {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }

        MainScheduler
            .asyncInstance
            .scheduleRelative(viewModel.sortingOption, dueTime: 0.2) {
                [weak self] sortingOption in
                guard let `self` = self else { return NopDisposable.instance }
                self.switchSortingOptionSubject.onNext(sortingOption)
                self.dismissViewControllerAnimatedSubject.onNext(true)
                return BooleanDisposable(disposed: true)
        }
    }
}
