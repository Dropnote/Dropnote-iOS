//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol BrewingsSortingViewModelType: TableViewConfigurable {
    var sortingOption: BrewingSortingOption { get set }
    func selectSortingOptionAtIndexPath(indexPath: NSIndexPath)
}

extension BrewingSortingOption: TitleImagePresentable {
    var title: String {
        switch self {
            case .DateAscending: return tr(.BrewingsSortingDateAscending)
            case .DateDescending: return tr(.BrewingsSortingDateDescending)
            case .ScoreAscending: return tr(.BrewingsSortingScoreAscending)
            case .ScoreDescending: return tr(.BrewingsSortingScoreDescending)
        }
    }

    var image: UIImage {
        switch self {
            case .DateAscending: return UIImage(asset: .Ic_oldest)
            case .DateDescending: return UIImage(asset: .Ic_newest)
            case .ScoreAscending: return UIImage(asset: .Ic_worst)
            case .ScoreDescending: return UIImage(asset: .Ic_best)
        }
    }
}

final class BrewingsSortingViewModel: BrewingsSortingViewModelType {
    var sortingOption: BrewingSortingOption = .DateDescending
    lazy var dataSource: TableViewSourceWrapper<BrewingsSortingViewModel> = TableViewSourceWrapper(tableDataSource: self)
    
    var listItems: [[BrewingSortingOption]] {
        return [BrewingSortingOption.allValues]
    }

    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = dataSource
    }
    
    func selectSortingOptionAtIndexPath(indexPath: NSIndexPath) {
        sortingOption = listItems[indexPath.section][indexPath.row]
    }
}

extension BrewingsSortingViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "BrewingsSortingOptionCell"
    }
    
    func listView(listView: UITableView, configureCell cell: BrewingsSortingOptionCell,
                  withObject object: BrewingSortingOption, atIndexPath indexPath: NSIndexPath) {
        cell.configureWithPresentable(object)
        if object == self.sortingOption {
            cell.accessoryType = .Checkmark
        }
    }
}
