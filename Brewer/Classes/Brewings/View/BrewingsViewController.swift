//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import DZNEmptyDataSet
import RxSwift
import RxCocoa

extension BrewingsViewController: ThemeConfigurable { }
extension BrewingsViewController: ThemeConfigurationContainer { }
extension BrewingsViewController: ResolvableContainer { }

final class BrewingsViewController: UIViewController {
    fileprivate lazy var filterBarButtonItem = UIBarButtonItem()

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIView()
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        return tableView
    }()

    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 44)))
        searchBar.placeholder = tr(.historyFilterPlaceholder)
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        return searchBar
    }()

    var themeConfiguration: ThemeConfiguration?
    let resolver: ResolverType
    private(set) var viewModel: BrewingsViewModelType
    fileprivate let isBrewDetailsEditable = true

    init(viewModel: BrewingsViewModelType, themeConfiguration: ThemeConfiguration? = nil, resolver: ResolverType = Assembler.sharedResolver) {
        self.viewModel = viewModel
        self.themeConfiguration = themeConfiguration
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        title = tr(.historyItemTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
   		view = tableView
   	}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchBar
        viewModel.configureWithTableView(tableView)

        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.configure(with: themeConfiguration)
        tableView.configure(with: themeConfiguration)
        tableView.hideSearchBar()

        filterBarButtonItem.title = nil
        filterBarButtonItem.image = viewModel.sortingOption.image
        navigationItem.rightBarButtonItem = filterBarButtonItem
        _ = filterBarButtonItem.rx.tap.bindNext {
            let sortingViewController = self.createSortingViewController()
            self.present(sortingViewController, animated: true)
        }

        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()

        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.brewings)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.hideSearchBar()
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
		guard let brew = viewModel.brew(for: activity) else { return }
        let brewDetailsViewController = resolver.resolve(BrewDetailsViewController.self, arguments: brew, isBrewDetailsEditable)!
        navigationController?.pushViewController(brewDetailsViewController, animated: true)
    }

    private func createSortingViewController() -> UIViewController {
        let sortingViewController = resolver.resolve(BrewingsSortingViewController.self, argument: viewModel.sortingOption)!
        _ = sortingViewController.dismissViewControllerAnimatedSubject.subscribe(onNext: {
            animated in
            self.dismiss(animated: animated, completion: nil)
        })
        _ = sortingViewController.switchSortingOptionSubject.subscribe(onNext: {
            sortingOption in
            self.viewModel.sortingOption = sortingOption
            self.tableView.reloadData()
        })
        return UINavigationController(rootViewController: sortingViewController)
    }
}

extension BrewingsViewController: TabBarConfigurable {

    func setupTabBar() {
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
        (cell as? BrewCell)?.configure(with: themeConfiguration)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brew = viewModel.brew(forIndexPath: indexPath)
        let brewDetailsViewController = resolver.resolve(BrewDetailsViewController.self, arguments: brew, isBrewDetailsEditable)!
        navigationController?.pushViewController(brewDetailsViewController, animated: true)
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

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return searchBar.text?.isEmpty ?? true
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(asset: .Ic_empty_history)
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 60
    }
}

extension BrewingsViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        let locationInTableView = tableView.convert(location, from: view)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableView) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        previewingContext.sourceRect = tableView.convert(cell.frame, to: view)

        let brew = viewModel.brew(forIndexPath: indexPath)
        return resolver.resolve(BrewDetailsViewController.self, arguments: brew, isBrewDetailsEditable)!
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
