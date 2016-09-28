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

    func brew(forIndexPath indexPath: IndexPath) -> Brew
    func setSearchText(_ searchText: String)
    func resetFilters()
}

final class BrewingsViewModel: BrewingsViewModelType {
    fileprivate(set) var brewsModelController: BrewingsModelControllerType
	fileprivate(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler<Brew>!
    
    var sortingOption: BrewingSortingOption = .dateDescending {
        didSet {
            brewsModelController.sortingOption = sortingOption
        }
    }
    
    fileprivate var brews: [Brew] {
        return brewsModelController.fetchedResultsController.fetchedItems()
    }
    
    var listItems: [[BrewCellViewModel]] {
        return [brews.map(BrewCellViewModel.init)]
    }
    
    lazy var dataSource: TableViewSourceWrapper<BrewingsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewsModelController: BrewingsModelControllerType) {
		self.brewsModelController = brewsModelController
	}

	func configureWithTableView(_ tableView: UITableView) {
		fetchedResultsControllerDelegate = TableViewFetchedResultsControllerDynamicChangesHandler(
			tableView: tableView,
			fetchedResultsController: brewsModelController.fetchedResultsController
        ) {
            tableView.reloadData()
        }
		tableView.dataSource = dataSource
	}
    
    func brew(forIndexPath indexPath: IndexPath) -> Brew {
        return brews[(indexPath as NSIndexPath).row]
    }
    
    func setSearchText(_ text: String) {
        brewsModelController.setSearchText(text)
    }
    
    func resetFilters() {
        brewsModelController.setSearchText(nil)
    }
}

extension BrewingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return "BrewCell"
    }
    
    func listView(_ listView: UITableView, configureCell cell: BrewCell, withObject object: BrewCellViewModel, atIndexPath indexPath: IndexPath) {
        cell.configureWithViewModel(object)
    }
}
