//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SequenceSettingsViewModelType: UITableViewDataSource, TableViewConfigurable {
    var brewMethod: BrewMethod! { get set }

    func prepareEditForTableView(tableView: UITableView, completion: (editing: Bool) -> ())

    func shouldSelectItemAtIndexPath(indexPath: NSIndexPath) -> Bool
    func markIndexPath(indexPath: NSIndexPath, asSelected selected: Bool)
}

final class SequenceSettingsViewModel: NSObject, SequenceSettingsViewModelType {
    private let disposeBag = DisposeBag()
    var dispatchHandler = Dispatcher.delay

    let modelController: SequenceSettingsModelControllerType
    var brewMethod: BrewMethod! {
        didSet {
            populateSections()
        }
    }

    private(set) var items: [BrewingSequenceStep] = []
    private(set) var editing = false

    private var activeItems: [BrewingSequenceStep] {
        return editing ? items : items.filter {
            $0.enabled!
        }
    }

    init(modelController: SequenceSettingsModelControllerType) {
        self.modelController = modelController
        super.init()
    }

    private func populateSections() {
        self.items = modelController.sequenceStepsForBrewMethod(brewMethod, filter: .All)
    }

    func configureWithTableView(tableView: UITableView) {
        tableView.dataSource = self
    }

    func prepareEditForTableView(tableView: UITableView, completion: (editing: Bool) -> ()) {
        editing = !editing
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        dispatchHandler(0.25) {
            completion(editing: self.editing)
        }
        if !editing {
            modelController.saveSequenceStepsForBrewMethod(brewMethod, sequenceSteps: items)
        }
    }

    // MARK: Selection

    func shouldSelectItemAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return items[indexPath.row].enabled!
    }

    func markIndexPath(indexPath: NSIndexPath, asSelected selected: Bool) {
        items[indexPath.row].setEnabled(selected)
    }
}

extension SequenceSettingsViewModel: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = activeItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("SequenceSettingsCell", forIndexPath: indexPath) as UITableViewCell
        cell.accessibilityHint = "Represents \(item.type!.description)"
        cell.textLabel?.text = item.type!.description
        cell.selected = item.enabled!
        return cell
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        var item = items[sourceIndexPath.row]
        item.setPosition(destinationIndexPath.row)
        items.removeAtIndex(sourceIndexPath.row)
        items.insert(item, atIndex: destinationIndexPath.row)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
