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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!

    var themeConfiguration: ThemeConfiguration?
    var viewModel: SequenceSettingsViewModelType!

    var brewMethod: BrewMethod! {
        didSet {
            viewModel.brewMethod = brewMethod
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.SequenceItemTitle)
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        editAction(editBarButtonItem)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.settingsSequence)
    }
    
    @IBAction func editAction(barButtonItem: UIBarButtonItem) {
        if barButtonItem.title == tr(.NavigationDone) {
            Dispatcher.delay(0.6) {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        barButtonItem.title = !tableView.editing ? tr(.NavigationDone) : tr(.NavigationEdit)
        viewModel.prepareEditForTableView(tableView) {
            editing in
            self.tableView.setEditing(editing, animated: true)
            self.selectRowsForTableViewIfNeeded()
        }
    }

    private func selectRowsForTableViewIfNeeded() {
        guard tableView.editing else { return }
        let selectRow = {
            self.tableView.selectRowAtIndexPath($0, animated: true, scrollPosition: .None)
        }
        tableView
            .indexPathsForVisibleRows?
            .filter(viewModel.shouldSelectItemAtIndexPath)
            .forEach(selectRow)
    }
}

extension SequenceSettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.markIndexPath(indexPath, asSelected: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        (cell as? SequenceSettingsCell)?.configureWithTheme(themeConfiguration)
    }
}
