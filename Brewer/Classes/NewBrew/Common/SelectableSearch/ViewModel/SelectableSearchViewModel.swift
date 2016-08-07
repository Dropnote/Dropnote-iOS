//
// Created by Maciej Oczko on 06.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

@objc protocol SelectableSearchModelItem {
    var name: String? { get set }
}

protocol SelectableSearchViewModelType: TableViewConfigurable {
    var placeholder: String { get }

    func setSearchString(search: String)
    func addNewSearchItemIfNeeded(search: String?)
    func selectItemAtIndexPath(indexPath: NSIndexPath)
}

final class SelectableSearchViewModel: NSObject, SelectableSearchViewModelType {
    
    private(set) var placeholder: String
    private(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler!
    private var selectedItemIndex: Int? {
        didSet {
            modelController.setItemIndex(selectedItemIndex)
        }
    }

    let modelController: SelectableSearchModelControllerType

    init(modelController: SelectableSearchModelControllerType) {
        self.modelController = modelController
        placeholder = modelController.placeholder ?? ""
    }

    lazy var dataSource: TableViewSourceWrapper<SelectableSearchViewModel> = TableViewSourceWrapper(tableDataSource: self)

    // MARK: Table View configuration

    var listItems: [[SelectableSearchModelItem]] {        
        return [modelController.fetchedResultsController.fetchedItems()]
    }

    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = dataSource
        fetchedResultsControllerDelegate =
            TableViewFetchedResultsControllerDynamicChangesHandler(
                tableView: tableView,
                fetchedResultsController: modelController.fetchedResultsController
        )
        selectedItemIndex = modelController.selectedItemIndex()
    }

    func selectItemAtIndexPath(indexPath: NSIndexPath) {
        selectedItemIndex = selectedItemIndex == indexPath.row ? nil : indexPath.row
        fetchedResultsControllerDelegate.refresh()
    }

    // MARK: Search

    func setSearchString(search: String) {
        let trimmedSearch = search.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        modelController.setSearchString(trimmedSearch)
        selectedItemIndex = nil
        fetchedResultsControllerDelegate.refresh()
    }
    
    func addNewSearchItemIfNeeded(search: String?) {
        guard listItems.first!.isEmpty else { return }
        guard let search = search else { return }
        
        let trimmedSearch = search.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        modelController.setSearchString(trimmedSearch)
        modelController.addSearchItem()
    }
}

extension SelectableSearchViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "SelectableSearchResultViewCell"
    }

    func listView(listView: UITableView, configureCell cell: UITableViewCell,
                  withObject object: SelectableSearchModelItem, atIndexPath indexPath: NSIndexPath) {
        
        cell.textLabel?.text = listItems[indexPath.section][indexPath.row].name
        
        if selectedItemIndex == indexPath.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
}
