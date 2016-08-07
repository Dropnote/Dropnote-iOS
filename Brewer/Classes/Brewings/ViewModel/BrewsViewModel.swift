//
//  BrewsViewmoModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa
import XCGLogger

protocol BrewingsViewModelType: TableViewConfigurable {
    var sortingOption: BrewingSortingOption { get set }

    func brew(forIndexPath indexPath: NSIndexPath) -> Brew
    func setSearchText(searchText: String)
    func resetFilters()
}

final class BrewingsViewModel: BrewingsViewModelType {
    private(set) var brewsModelController: BrewingsModelControllerType
	private(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler!
    
    var sortingOption: BrewingSortingOption = .DateDescending {
        didSet {
            brewsModelController.sortingOption = sortingOption
        }
    }
    
    private var brews: [Brew] {
        return brewsModelController.fetchedResultsController.fetchedItems()
    }
    
    var listItems: [[BrewCellViewModel]] {
        return [brews.map(BrewCellViewModel.init)]
    }
    
    lazy var dataSource: TableViewSourceWrapper<BrewingsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewsModelController: BrewingsModelControllerType) {
		self.brewsModelController = brewsModelController
	}

	func configureWithTableView(tableView: UITableView) {
		fetchedResultsControllerDelegate = TableViewFetchedResultsControllerDynamicChangesHandler(
			tableView: tableView,
			fetchedResultsController: brewsModelController.fetchedResultsController
        ) {
            tableView.reloadData()
        }
		tableView.dataSource = dataSource
	}
    
    func brew(forIndexPath indexPath: NSIndexPath) -> Brew {
        return brews[indexPath.row]
    }
    
    func setSearchText(text: String) {
        brewsModelController.setSearchText(text)
    }
    
    func resetFilters() {
        brewsModelController.setSearchText(nil)
    }
}

extension BrewingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "BrewCell"
    }
    
    func listView(listView: UITableView, configureCell cell: BrewCell, withObject object: BrewCellViewModel, atIndexPath indexPath: NSIndexPath) {
        cell.configureWithViewModel(object)
    }
}
