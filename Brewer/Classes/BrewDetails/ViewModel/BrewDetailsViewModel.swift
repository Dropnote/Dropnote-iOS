//
//  BrewDetailsViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 17.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum BrewDetailsTableViewSection: Int {
	case Score = 0
	case CoffeeInfo = 1
	case Attributes = 2
	case Notes = 3
    case Remove = 4

	var cellIdentifier: String {
		switch self {
		case .Score:
			return "FinalScoreCell"
		case .CoffeeInfo, .Attributes:
			return "BrewAttributeCell"
		case .Notes:
			return "BrewNotesCell"
        case .Remove:
            return "BrewDetailsRemoveCell"
		}
	}
}

protocol BrewDetailsViewModelType: TableViewConfigurable {
	var editable: Bool { get set }
	var brewModelController: BrewModelControllerType { get }

	func refreshData()
	
    func sectionType(forIndexPath indexPath: NSIndexPath) -> BrewDetailsTableViewSection
    func brewAttributeType(forIndexPath indexPath: NSIndexPath) -> BrewAttributeType
    func coffeeAttribute(forIndexPath indexPath: NSIndexPath) -> SelectableSearchIdentifier
    
	func currentBrew() -> Brew
    func removeCurrentBrew(completion: (Bool -> Void))
	func saveBrewIfNeeded()
}

struct BrewDetailsPresentable: TitleValuePresentable {
	var title: String
	var value: String
	var attribute: BrewAttributeType?
	var selectableSearchIdentifier: SelectableSearchIdentifier?

	init(attribute: BrewAttribute) {
		let attributeType = BrewAttributeType.fromIntValue(attribute.type)
		self.attribute = attributeType
		title = attributeType.description
		value = attributeType.format(attribute.value, withUnitType: attribute.unit)
	}

	init(title: String, value: String) {
		self.title = title
		self.value = value
	}

	init(title: String, value: String, identifier: BrewAttributeType?) {
		self.title = title
		self.value = value
		self.attribute = identifier
	}

	init(title: String, value: String, identifier: SelectableSearchIdentifier?) {
		self.title = title
		self.value = value
		self.selectableSearchIdentifier = identifier
	}
}

final class BrewDetailsViewModel: BrewDetailsViewModelType {
	private let disposeBag = DisposeBag()
	let brewModelController: BrewModelControllerType
	var editable: Bool = false
    
    private lazy var dataSource: TableViewSourceWrapper<BrewDetailsViewModel> = TableViewSourceWrapper(tableDataSource: self)

	init(brewModelController: BrewModelControllerType) {
		self.brewModelController = brewModelController
	}

	func configureWithTableView(tableView: UITableView) {
		refreshData()
		tableView.dataSource = dataSource
	}

	func currentBrew() -> Brew {
		return brewModelController.currentBrew()!
	}

	func saveBrewIfNeeded() {
		if editable {
			brewModelController.saveBrew().subscribeError {
				print(($0 as NSError).localizedDescription)
			}.addDisposableTo(disposeBag)
		}
	}

	var listItems: [[TitleValuePresentable]] = []

	func refreshData() {
		let presentables: [TitleValuePresentable] = currentBrew().brewAttributesArray().map(BrewDetailsPresentable.init)
		listItems.removeAll()
        
        var scoreValue = "?"
        if currentBrew().score > 0 {
            scoreValue = currentBrew().score.format(".1")
        }
        
		listItems.append([
			BrewDetailsPresentable(title: tr(.BrewDetailScore), value: scoreValue)
		])

		var coffeePresentables: [TitleValuePresentable] = [
			BrewDetailsPresentable(
				title: SelectableSearchIdentifier.Coffee.description,
				value: currentBrew().coffee?.name ?? "",
				identifier: .Coffee)
		]
		if let coffeeMachine = currentBrew().coffeeMachine {
			coffeePresentables.append(
				BrewDetailsPresentable(
					title: SelectableSearchIdentifier.CoffeeMachine.description,
					value: coffeeMachine.name ?? "",
					identifier: .CoffeeMachine
                )
			)
		}
		listItems.append(coffeePresentables)
		listItems.append(presentables)
		listItems.append([
			BrewDetailsPresentable(
				title: tr(.AttributeNotes),
				value: currentBrew().notes ?? "",
				identifier: .Notes)
		])
        if editable {
            listItems.append([BrewDetailsPresentable(title: tr(.BrewDetailsRemoveTitle), value: "")])
        }
	}

	func sectionType(forIndexPath indexPath: NSIndexPath) -> BrewDetailsTableViewSection {
		if let sectionType = BrewDetailsTableViewSection(rawValue: indexPath.section) {
			return sectionType
		}
		fatalError("No section type for \(indexPath.section)")
	}
    
    func brewAttributeType(forIndexPath indexPath: NSIndexPath) -> BrewAttributeType {
        let item = listItems[indexPath.section].elements(ofType: BrewDetailsPresentable.self)[indexPath.row]
        return item.attribute!
    }
    
    func coffeeAttribute(forIndexPath indexPath: NSIndexPath) -> SelectableSearchIdentifier {
        let item = listItems[indexPath.section].elements(ofType: BrewDetailsPresentable.self)[indexPath.row]
        return item.selectableSearchIdentifier!
    }
    
    func removeCurrentBrew(completion: (Bool -> Void)) {
        brewModelController.removeCurrentBrew().subscribeNext(completion).addDisposableTo(disposeBag)
    }
}

extension BrewDetailsViewModel: TableListDataSource {
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return sectionType(forIndexPath: indexPath).cellIdentifier
    }
    
    func listView(listView: UITableView, configureCell cell: UITableViewCell, withObject object: TitleValuePresentable, atIndexPath indexPath: NSIndexPath) {
        let sectionType = self.sectionType(forIndexPath: indexPath)
        if sectionType != .Score && sectionType != .Remove {
            cell.accessoryType = editable ? .DisclosureIndicator : .None
        }
        let presentable = listItems[indexPath.section][indexPath.row]
        (cell as? FinalScoreCell)?.configureWithPresentable(presentable)
        (cell as? BrewAttributeCell)?.configureWithPresentable(presentable)
        (cell as? BrewNotesCell)?.configureWithPresentable(presentable)
        (cell as? BrewDetailsRemoveCell)?.configureWithPresentable(presentable)
    }
}
