//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol MethodPickerViewModelType: TableViewConfigurable {
    func methodForIndexPath(indexPath: NSIndexPath) -> BrewMethod
}

final class MethodPickerViewModel: MethodPickerViewModelType {
    var listItems = [
        BrewMethod.allValues.map { $0 as TitleImagePresentable }
    ]
    
    lazy var dataSource: TableViewSourceWrapper<MethodPickerViewModel> = {
        return TableViewSourceWrapper(tableDataSource: self)
    }()
   
    func methodForIndexPath(indexPath: NSIndexPath) -> BrewMethod {
        return objectAtIndexPath(indexPath) as! BrewMethod
    }
}

extension MethodPickerViewModel: TableViewConfigurable {
    
    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = dataSource
    }
}

extension MethodPickerViewModel: TableListDataSource {

    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "MethodPickerCell"
    }
    
    func listView(listView: UITableView, configureCell cell: MethodPickerCell, withObject object: TitleImagePresentable, atIndexPath indexPath: NSIndexPath) {
        cell.configureWithPresentable(object)
    }
}
