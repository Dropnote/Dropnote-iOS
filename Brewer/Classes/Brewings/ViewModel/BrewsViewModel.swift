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
import CoreSpotlight
import MobileCoreServices

protocol BrewingsViewModelType: TableViewConfigurable {
    var sortingOption: BrewingSortingOption { get set }

    func brew(forIndexPath indexPath: IndexPath) -> Brew
	func brew(for activity: NSUserActivity) -> Brew?
    func search(for text: String?)
    func resetFilters()
}

final class BrewingsViewModel: BrewingsViewModelType {
    fileprivate(set) var brewsModelController: BrewingsModelControllerType
	fileprivate(set) var fetchedResultsControllerDelegate: TableViewFetchedResultsControllerDynamicChangesHandler<Brew>!

	private let spotlightSearchService: SpotlightSearchService
    
    var sortingOption: BrewingSortingOption = .dateDescending {
        didSet {
            brewsModelController.sortingOption = sortingOption
        }
    }
    
    fileprivate var brews: [Brew] {
        return brewsModelController.fetchedResultsController.fetchedObjects ?? []
    }
    
    var listItems: [[BrewCellViewModel]] {
        return [brews.map(BrewCellViewModel.init)]
    }
    
    lazy var dataSource: TableViewSourceWrapper<BrewingsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewsModelController: BrewingsModelControllerType, spotlightSearchService: SpotlightSearchService) {
		self.brewsModelController = brewsModelController
		self.spotlightSearchService = spotlightSearchService
	}

	func configure(with tableView: UITableView) {
		tableView.register(BrewCell.self, forCellReuseIdentifier: String(describing: BrewCell.self))
		fetchedResultsControllerDelegate = TableViewFetchedResultsControllerDynamicChangesHandler(
			tableView: tableView,
			fetchedResultsController: brewsModelController.fetchedResultsController
        ) { [weak self] in
            tableView.reloadData()
			guard let `self` = self else { return }
			self.spotlightSearchService.updateSearchableIndex(with: self.brews)
        }
		tableView.dataSource = dataSource
	}
    
    func brew(forIndexPath indexPath: IndexPath) -> Brew {
        return brews[indexPath.row]
    }
    
    func search(for text: String?) {
        brewsModelController.search(for: text)
    }
    
    func resetFilters() {
        brewsModelController.search(for: nil)
    }

	func brew(for activity: NSUserActivity) -> Brew? {
		return spotlightSearchService.selectedBrew(for: activity, from: brews)
	}
}

extension BrewingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return String(describing: BrewCell.self)
    }
    
    func listView(_ listView: UITableView, configureCell cell: BrewCell, withObject object: BrewCellViewModel, atIndexPath indexPath: IndexPath) {
        cell.configureWithViewModel(object)
    }
}
