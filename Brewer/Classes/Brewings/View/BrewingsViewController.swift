//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import DZNEmptyDataSet
import RxSwift

extension BrewingsViewController: ThemeConfigurable { }
extension BrewingsViewController: ThemeConfigurationContainer { }
extension BrewingsViewController: ResolvableContainer { }

final class BrewingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterBarButtonItem: UIBarButtonItem!
    
    fileprivate var searchBar: UISearchBar!
    var themeConfiguration: ThemeConfiguration?
    var resolver: ResolverType?
    var viewModel: BrewingsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tr(.historyItemTitle)
        configureWithTheme(themeConfiguration)
        
        searchBar = UISearchBar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 44)))
        searchBar.placeholder = tr(.historyFilterPlaceholder)
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.backgroundView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableHeaderView = searchBar
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        viewModel.configureWithTableView(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        tableView.hideSearchBar()
        filterBarButtonItem.title = nil
        filterBarButtonItem.image = viewModel.sortingOption.image
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
        
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewings)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case .BrewDetails = segueIdentifierForSegue(segue), let brew = sender as? Brew {
            guard let resolver = resolver else { return }
            guard let brewDetailsViewController = segue.destination as? BrewDetailsViewController else { return }
            brewDetailsViewController.viewModel = resolver.resolve(BrewDetailsViewModelType.self, argument: brew)
            brewDetailsViewController.viewModel.editable = true
        }
        if case .BrewingsSorting = segueIdentifierForSegue(segue) {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let brewingsSortingViewController = navigationController.topViewController as? BrewingsSortingViewController else { return }
            brewingsSortingViewController.viewModel.sortingOption = viewModel.sortingOption

            _ = brewingsSortingViewController.dismissViewControllerAnimatedSubject.subscribeNext {
                animated in
                self.dismiss(animated: animated, completion: nil)
            }
            _ = brewingsSortingViewController.switchSortingOptionSubject.subscribeNext {
                sortingOption in
                self.viewModel.sortingOption = sortingOption
                self.tableView.reloadData()
            }
        }
    }
}

extension BrewingsViewController: TabBarConfigurable {
    
    func setupTabBar() {
        tabBarItem = nil
        tabBarItem = UITabBarItem(title: tr(.historyItemTitle),
                                  image: UIImage(asset: .Ic_tab_history)?.alwaysOriginal(),
                                  selectedImage: UIImage(asset: .Ic_tab_history_pressed)?.alwaysOriginal())
    }
}

extension BrewingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \((indexPath as NSIndexPath).row + 1)"
        (cell as? BrewCell)?.configureWithTheme(themeConfiguration)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(.BrewDetails, sender: viewModel.brew(forIndexPath: indexPath))
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y == 0 && scrollView.contentOffset.y > searchBar.frame.size.height {
            targetContentOffset.pointee.y = searchBar.frame.size.height
        }
    }
}

extension BrewingsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.hideSearchBar(animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetFilters()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableView.hideSearchBar(animated: true)
    }
}

extension BrewingsViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: themeConfiguration?.defaultFontWithSize(17) ?? UIFont.systemFont(ofSize: 17)
        ]
        return NSAttributedString(string: tr(.historyEmptySetDescription), attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(asset: .Ic_empty_history)
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 60
    }
}
