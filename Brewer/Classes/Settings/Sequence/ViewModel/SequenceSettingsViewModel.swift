//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SequenceSettingsViewModelType: UITableViewDataSource, TableViewConfigurable {
    var brewMethod: BrewMethod { get }

    func prepareEdit(for tableView: UITableView, completion: @escaping (_ editing: Bool) -> Void)

    func shouldSelectItem(at indexPath: IndexPath) -> Bool
    func markItem(at indexPath: IndexPath, asSelected selected: Bool)
}

final class SequenceSettingsViewModel: NSObject, SequenceSettingsViewModelType {
    fileprivate let disposeBag = DisposeBag()
    private var dispatchHandler = Dispatcher.delay

    let modelController: SequenceSettingsModelControllerType
    let brewMethod: BrewMethod

    fileprivate(set) var items: [BrewingSequenceStep] = []
    fileprivate(set) var editing = false

    fileprivate var activeItems: [BrewingSequenceStep] {
        return editing ? items : items.filter {
            $0.enabled!
        }
    }

    init(brewMethod: BrewMethod, modelController: SequenceSettingsModelControllerType) {
        self.brewMethod = brewMethod
        self.modelController = modelController
        super.init()
        populateSections()
    }

    fileprivate func populateSections() {
        self.items = modelController.sequenceSteps(for: brewMethod, filter: .all)
    }

    func configure(with tableView: UITableView) {
        tableView.register(SequenceSettingsCell.self, forCellReuseIdentifier: String(describing: SequenceSettingsCell.self))
        tableView.dataSource = self
    }

    func prepareEdit(for tableView: UITableView, completion: @escaping (_ editing: Bool) -> Void) {
        editing = !editing
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        dispatchHandler(0.25) {
            completion(self.editing)
        }
        if !editing {
            modelController.saveSequenceSteps(for: brewMethod, sequenceSteps: items)
        }
    }

    // MARK: Selection

    func shouldSelectItem(at indexPath: IndexPath) -> Bool {
        return items[indexPath.row].enabled!
    }

    func markItem(at indexPath: IndexPath, asSelected selected: Bool) {
        items[indexPath.row].set(enabled: selected)
    }
}

extension SequenceSettingsViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = activeItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SequenceSettingsCell.self), for: indexPath) as UITableViewCell
        cell.accessibilityHint = "Represents \(item.type!.description)"
        cell.textLabel?.text = item.type!.description
        cell.isSelected = item.enabled!
        return cell
    }

    func tableView(_ tableView: UITableView, moveRowAt source: IndexPath, to destination: IndexPath) {
        var item = items[source.row]
        item.set(position: destination.row)
        items.remove(at: source.row)
        items.insert(item, at: destination.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
