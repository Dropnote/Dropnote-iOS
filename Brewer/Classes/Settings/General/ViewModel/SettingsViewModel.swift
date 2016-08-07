//
// Created by Maciej Oczko on 21.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

struct SettingsItem: TitlePresentable {
    let title: String
}

final class SettingsViewModel {
    
    var listItems = [[
            SettingsItem(title: tr(.SettingsBrewingSequenceMenuItemTitle)),
            SettingsItem(title: tr(.SettingsUnitsMenuItemTitle)),
            SettingsItem(title: tr(.SettingsAboutMenuItemTitle)),
            SettingsItem(title: tr(.SettingsFeedbackMenuItemTitle)),
    ]]
    
    lazy var dataSource: TableViewSourceWrapper<SettingsViewModel> = TableViewSourceWrapper(tableDataSource: self)
}

extension SettingsViewModel: TableViewConfigurable {
    
    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = dataSource
    }
}

extension SettingsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return "SettingsCell"
    }
    
    func listView(listView: UITableView, configureCell cell: SettingsCell, withObject object: SettingsItem, atIndexPath indexPath: NSIndexPath) {
        cell.configureWithPresentable(object)
    }
}
