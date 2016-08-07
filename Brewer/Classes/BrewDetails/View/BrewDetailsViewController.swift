//
//  BrewDetailsViewController.swift
//  Brewer
//
//  Created by Maciej Oczko on 09.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import Box

extension BrewDetailsViewController: ThemeConfigurable { }
extension BrewDetailsViewController: ThemeConfigurationContainer { }
extension BrewDetailsViewController: ResolvableContainer { }

final class BrewDetailsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	var resolver: ResolverType?
	var themeConfiguration: ThemeConfiguration?
	var viewModel: BrewDetailsViewModelType!

    private weak var pushedViewController: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.BrewDetailsItemTitle)
		
		tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
		tableView.delegate = self
		viewModel.configureWithTableView(tableView)

        enableSwipeToBack()
        navigationController?.delegate = self
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        deactivatePushedViewController()
        
        configureWithTheme(themeConfiguration)
		tableView.configureWithTheme(themeConfiguration)
		viewModel.refreshData()

        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewDetails)
	}
    
	override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveBrewIfNeeded()
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let resolver = resolver else { return }

		switch segueIdentifierForSegue(segue) {
		case .BrewScoreDetails:
			let viewController = segue.destinationViewController as! BrewScoreDetailsViewController
			viewController.viewModel = resolver.resolve(BrewScoreDetailsViewModelType.self,
														argument: viewModel.currentBrew())!
			break
		case .GrindSize:
			let viewController = segue.destinationViewController as! GrindSizeViewController
			viewController.viewModel = resolver.resolve(GringSizeViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .NumericalInput:
			guard let box = sender as? Box<BrewAttributeType> else {
				fatalError("Couldn't unbox necessary context.")
			}
			let viewController = segue.destinationViewController as! NumericalInputViewController
			viewController.title = box.value.description
			viewController.viewModel = resolver.resolve(NumericalInputViewModelType.self,
														arguments: (box.value, viewModel.brewModelController))!
			break
		case .Tamping:
			let viewController = segue.destinationViewController as! TampingViewController
			viewController.viewModel = resolver.resolve(TampingViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .Notes:
			let viewController = segue.destinationViewController as! NotesViewController
			viewController.viewModel = resolver.resolve(NotesViewModelType.self,
														argument: viewModel.brewModelController)!
			break
		case .SelectableSearch:
			guard let box = sender as? Box<SelectableSearchIdentifier> else {
				fatalError("Couldn't unbox necessary context.")
			}
			let viewController = segue.destinationViewController as! SelectableSearchViewController
			viewController.viewModel = resolver.resolve(SelectableSearchViewModelType.self,
														arguments: (box.value, viewModel.brewModelController))!
			viewController.title = box.value.description
			break
		default:
			fatalError("Unknown segue performed.")
		}

        segue.destinationViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(asset: .Ic_back),
            style: .Plain,
            target: self,
            action: #selector(pop)
        )
        segue.destinationViewController.enableSwipeToBack()
        pushedViewController = segue.destinationViewController
	}

    private func deactivatePushedViewController() {
        if let pushedViewController = pushedViewController {
            if var activable = pushedViewController as? Activable {
                activable.active = false
            }
            self.pushedViewController = nil
        }
    }

    private func removeCurrentBrewIfNeeded() {
        let alertController = UIAlertController(title: tr(.BrewScoreDetailsItemTitle), message: tr(.BrewDetailsConfirmationTitle), preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: tr(.BrewDetailsConfirmationYes), style: .Destructive) {
            _ in
            self.viewModel.removeCurrentBrew {
                [weak self] didRemove in
                if didRemove {
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            }
        })
        alertController.addAction(UIAlertAction(title: tr(.BrewDetailsConfirmationNo), style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension BrewDetailsViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = true
    }

    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
    }

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
		(cell as? FinalScoreCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewAttributeCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewNotesCell)?.configureWithTheme(themeConfiguration)
		(cell as? BrewDetailsRemoveCell)?.configureWithTheme(themeConfiguration)
        if case .DisclosureIndicator = cell.accessoryType {
            cell.accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        } else {
            cell.accessoryView = nil
        }
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch viewModel.sectionType(forIndexPath: indexPath) {
		case .Score:
			performSegue(.BrewScoreDetails)
			break
		case .CoffeeInfo:
			guard viewModel.editable else { return }
            let selectableSearchIdentifier = viewModel.coffeeAttribute(forIndexPath: indexPath)
            performSegue(.SelectableSearch, sender: Box(selectableSearchIdentifier))
			break
		case .Attributes:
			guard viewModel.editable else { return }
			let brewAttributeType = viewModel.brewAttributeType(forIndexPath: indexPath)
			performSegue(brewAttributeType.segueIdentifier, sender: Box(brewAttributeType))
			break
		case .Notes:
			performSegue(.Notes, sender: Box<BrewAttributeType>(.Notes))
			break
        case .Remove:
            removeCurrentBrewIfNeeded()
            break
		}
	}
}

extension BrewDetailsViewController: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if var activable = viewController as? Activable {
            activable.active = true
        }
    }
}
