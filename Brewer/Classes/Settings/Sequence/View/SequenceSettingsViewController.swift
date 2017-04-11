//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension SequenceSettingsViewController: ThemeConfigurable { }
extension SequenceSettingsViewController: ThemeConfigurationContainer { }

final class SequenceSettingsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        return tableView
    }()
    private lazy var editBarButtonItem = UIBarButtonItem(title: tr(.navigationEdit),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(editAction))

    var themeConfiguration: ThemeConfiguration?
    let viewModel: SequenceSettingsViewModelType

    init(viewModel: SequenceSettingsViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
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
        title = tr(.sequenceItemTitle)
        viewModel.configureWithTableView(tableView)
        enableSwipeToBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.configure(with: themeConfiguration)
        editAction(editBarButtonItem)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsSequence)
    }
    
    func editAction(_ barButtonItem: UIBarButtonItem) {
        if barButtonItem.title == tr(.navigationDone) {
            Dispatcher.delay(0.6) {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        barButtonItem.title = !tableView.isEditing ? tr(.navigationDone) : tr(.navigationEdit)
        viewModel.prepareEditForTableView(tableView) {
            editing in
            self.tableView.setEditing(editing, animated: true)
            self.selectRowsForTableViewIfNeeded()
        }
    }

    fileprivate func selectRowsForTableViewIfNeeded() {
        guard tableView.isEditing else { return }
        let selectRow = {
            self.tableView.selectRow(at: $0, animated: true, scrollPosition: .none)
        }
        tableView
            .indexPathsForVisibleRows?
            .filter(viewModel.shouldSelectItemAtIndexPath)
            .forEach(selectRow)
    }
}

extension SequenceSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? SequenceSettingsCell)?.configure(with: themeConfiguration)
    }
}
