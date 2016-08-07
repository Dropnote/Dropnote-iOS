//
// Created by Maciej Oczko on 20.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol UnitsViewModelType: TableViewConfigurable {
    var titles: [String] { get }

    func setDataSourceAtIndex(index: Int)
    
    func selectUnitAtIndex(index: Int)
    func isSelectedUnitAtIndex(index: Int) -> Bool
}

final class UnitsViewModel: UnitsViewModelType {
    let modelController: UnitsModelControllerType
    let dataSources: [UnitsDataSourceType]
    private(set) weak var currentDataSource: UnitsDataSourceType?

    init(modelController: UnitsModelControllerType, dataSourcesFactory: UnitsDataSourcesFactoryType) {
        self.modelController = modelController
        self.dataSources = dataSourcesFactory.dataSources
        self.currentDataSource = dataSources.first
    }

    var titles: [String] {
        return dataSources.map { $0.title }
    }
    
    var listItems: [[UnitsDataSourceItem]] {
        get {
            if let currentDataSource = currentDataSource {
                return [currentDataSource.items]
            }
            return []
        }
    }
    
    lazy var dataSource: TableViewSourceWrapper<UnitsViewModel> = TableViewSourceWrapper(tableDataSource: self)

    func setDataSourceAtIndex(index: Int) {
        precondition(index < dataSources.count, "Index too high!")
        currentDataSource = dataSources[index]
    }
    
    // MARK: Unit selection

    func selectUnitAtIndex(index: Int) {
        guard let dataSource = currentDataSource else { return }
        modelController.setRawUnit(dataSource.items[index].key, forCategory: dataSource.category)
    }

    func isSelectedUnitAtIndex(index: Int) -> Bool {
        guard let dataSource = currentDataSource else { return false }
        return modelController.rawUnit(forCategory: dataSource.category) == dataSource.items[index].key
    }
}

extension UnitsViewModel: TableViewConfigurable {
    
    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = dataSource
    }
}

extension UnitsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "UnitsViewCell"
    }
    
    func listView(listView: UITableView, configureCell cell: UITableViewCell, withObject object: UnitsDataSourceItem, atIndexPath indexPath: NSIndexPath) {
        cell.accessibilityHint = "Selects unit \(currentDataSource!.items[indexPath.row].title)"
        cell.textLabel?.text = currentDataSource!.items[indexPath.row].title
        cell.accessoryType = isSelectedUnitAtIndex(indexPath.row) ? .Checkmark : .None
    }
}
