//
// Created by Maciej Oczko on 01.05.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension BrewScoreDetailsViewController: ThemeConfigurationContainer { }

final class BrewScoreDetailsViewController: UIViewController {
	private let disposeBag = DisposeBag()
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: BrewScoreDetailsHeaderView!
    
    private lazy var doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "ic_done")!,
        style: .Plain,
        target: self,
        action: #selector(done)
    )
	
    var themeConfiguration: ThemeConfiguration?
    var viewModel: BrewScoreDetailsViewModelType!
    private var shouldSaveScore = false

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.BrewScoreDetailsItemTitle)
        headerView.titleLabel.text = tr(.BrewDetailScore)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
		viewModel.scoreValue
			.asObservable()
            .bindTo(headerView.valueLabel.rx_text)
			.addDisposableTo(disposeBag)
        
        tableView.delegate = self
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = 80
		tableView.rowHeight = UITableViewAutomaticDimension
		viewModel.configureWithTableView(tableView)
        
        enableSwipeToBack()
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.configureWithTheme(themeConfiguration)
        headerView.configureWithTheme(themeConfiguration)
        tableView.configureWithTheme(themeConfiguration)
        
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.scoreDetails)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldSaveScore {
            viewModel.saveScore()
        } else {
            viewModel.dropScoreChanges()
        }
    }
    
    @objc private func done() {
        shouldSaveScore = true
        navigationController?.popViewControllerAnimated(true)
    }
}

extension BrewScoreDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        (cell as? BrewScoreDetailCell)?.configureWithTheme(themeConfiguration)
    }
}
