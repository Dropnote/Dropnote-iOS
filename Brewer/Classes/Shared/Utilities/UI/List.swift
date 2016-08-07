import Foundation
import UIKit

protocol ListDataSource {
    associatedtype ListView
    associatedtype Cell
    associatedtype Object
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String
    func listView(listView: ListView, configureCell cell: Cell, withObject object: Object, atIndexPath indexPath: NSIndexPath)
}

// --

protocol NonFetchedListDataSource: ListDataSource {
    var listItems: [[Object]] { get }
}

extension NonFetchedListDataSource {
    var numberOfSections: Int {
        return listItems.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return listItems[section].count
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        guard isValidIndexPath(indexPath) else {
            return nil
        }
        return listItems[indexPath.section][indexPath.row]
    }
    
    func isValidIndexPath(indexPath: NSIndexPath) -> Bool {
        guard indexPath.section >= 0 && indexPath.section < listItems.count else {
            return false
        }
        return indexPath.row >= 0 && indexPath.row < listItems[indexPath.section].count
    }
}

// --

protocol TableListDataSource: NonFetchedListDataSource { }

extension TableListDataSource where ListView == UITableView {
    
    func tableCellAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> Cell {
        let identifier = cellIdentifierForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! Cell
        
        if let object = objectAtIndexPath(indexPath) {
            listView(tableView, configureCell: cell, withObject: object, atIndexPath: indexPath)
        }
        
        return cell
    }
}

// --

final class TableViewSourceWrapper<T where T: AnyObject, T: TableListDataSource, T.ListView == UITableView>: NSObject, UITableViewDataSource {
    unowned let tableDataSource: T
    
    init(tableDataSource: T) {
        self.tableDataSource = tableDataSource
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableDataSource.numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableDataSource.tableCellAtIndexPath(tableView, indexPath: indexPath) as! UITableViewCell
    }
}

protocol TableViewConfigurable {
    func configureWithTableView(tableView: UITableView)
}
