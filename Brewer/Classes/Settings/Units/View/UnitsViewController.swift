//
//  UnitsViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 10.02.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UnitsViewController: ThemeConfigurable { }
extension UnitsViewController: ThemeConfigurationContainer { }

final class UnitsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: UnitsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.UnitsItemTitle)
        
        setUpSegementedControlTitles()
        setDataSourceAtIndex(0)
        setUpSwitchingDataSources()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        unitsSegmentedControl.configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsUnits)
    }

    // MARK: Configuration

    private func setUpSegementedControlTitles() {
        viewModel.titles.enumerate().map {
            index, title in (title, index)
        }.forEach(unitsSegmentedControl.setTitle)
        
        unitsSegmentedControl.accessibilityHint = "Chooses between units categories " + viewModel.titles.joinWithSeparator(",")
    }

    // MARK: Data source switching

    private func setUpSwitchingDataSources() {
        unitsSegmentedControl
            .rx_value
            .asDriver()
            .drive(onNext: setDataSourceAtIndex)
            .addDisposableTo(disposeBag)
    }
    
    private func setDataSourceAtIndex(index: Int) {
        viewModel.setDataSourceAtIndex(index)
        tableView.reloadData()
    }
}

extension UnitsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.selectUnitAtIndex(indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        cell.configureWithTheme(themeConfiguration)
        cell.textLabel?.configureWithTheme(themeConfiguration)
        cell.detailTextLabel?.configureWithTheme(themeConfiguration)        
    }
}
