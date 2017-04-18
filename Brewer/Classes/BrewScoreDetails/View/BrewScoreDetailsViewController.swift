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
	fileprivate let disposeBag = DisposeBag()
	
	lazy var brewScoreDetailsView = BrewScoreDetailsView()

	fileprivate var tableView: UITableView {
		return brewScoreDetailsView.tableView
	}
	fileprivate var headerView: BrewScoreDetailsHeaderView {
		return brewScoreDetailsView.headerView
	}
    
    fileprivate lazy var doneBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "ic_done")!,
        style: .plain,
        target: self,
        action: #selector(done)
    )
	
    var themeConfiguration: ThemeConfiguration?
    let viewModel: BrewScoreDetailsViewModelType
    fileprivate var shouldSaveScore = false

	init(viewModel: BrewScoreDetailsViewModelType, themeConfiguration: ThemeConfiguration? = nil) {
		self.viewModel = viewModel
		self.themeConfiguration = themeConfiguration
		super.init(nibName: nil, bundle: nil)
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func loadView() {
		view = brewScoreDetailsView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.brewScoreDetailsItemTitle)
        headerView.titleLabel.text = tr(.brewDetailScore)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
		viewModel.scoreValue
			.asObservable()
            .bindTo(headerView.valueLabel.rx.text)
			.addDisposableTo(disposeBag)
        
        tableView.delegate = self
		viewModel.configure(with: tableView)

		setupDefaultBackBarButtonItemIfNeeded()
		enableSwipeToBack()

		headerView.alpha = 0
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brewScoreDetailsView.configure(with: themeConfiguration)
		transitionCoordinator?.animate(alongsideTransition: { _ in
			self.headerView.alpha = 1
		})
		Analytics.sharedInstance.trackScreen(withTitle: AppScreen.scoreDetails)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldSaveScore {
            viewModel.saveScore()
        } else {
            viewModel.dropScoreChanges()
        }
		transitionCoordinator?.animate(alongsideTransition: { _ in
			self.headerView.alpha = 0
		})
    }
    
    @objc fileprivate func done() {
        shouldSaveScore = true
        _ = navigationController?.popViewController(animated: true)
    }
}

extension BrewScoreDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessibilityLabel = "Select \(indexPath.row + 1)"
        (cell as? BrewScoreDetailCell)?.configure(with: themeConfiguration)
    }
}
