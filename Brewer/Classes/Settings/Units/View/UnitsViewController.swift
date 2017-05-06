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
    fileprivate let disposeBag = DisposeBag()

    private lazy var unitsView = UnitsView()

    private var unitsSegmentedControl: UISegmentedControl {
        return unitsView.segmentedControl
    }

    private var tableView: UITableView {
        return unitsView.tableView
    }

    var themeConfiguration: ThemeConfiguration?
    let viewModel: UnitsViewModelType

    init(viewModel: UnitsViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
        title = tr(.unitsItemTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = unitsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSegmentedControlTitles()
        setUpSwitchingDataSources()

        tableView.delegate = self
        viewModel.configure(with: tableView)

        enableSwipeToBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unitsSegmentedControl.selectedSegmentIndex = 0
        unitsView.configure(with: themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsUnits)
    }

    // MARK: Configuration

    fileprivate func setUpSegmentedControlTitles() {
        viewModel.titles.enumerated().map {
            index, title in (title, index, false)
        }.forEach(unitsSegmentedControl.insertSegment(withTitle:at:animated:))
        
        unitsSegmentedControl.accessibilityHint = "Chooses between units categories " + viewModel.titles.joined(separator: ",")
    }

    // MARK: Data source switching

    fileprivate func setUpSwitchingDataSources() {
        unitsSegmentedControl
            .rx.value
            .asDriver()
            .drive(onNext: setDataSourceAtIndex)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func setDataSourceAtIndex(_ index: Int) {
        viewModel.setDataSourceAtIndex(index)
        tableView.reloadData()
    }
}

extension UnitsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectUnitAtIndex(indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        cell.configure(with: themeConfiguration)
        cell.textLabel?.configure(with: themeConfiguration)
        cell.detailTextLabel?.configure(with: themeConfiguration)
    }
}
