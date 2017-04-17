//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCGLogger

extension NewBrewViewController: ThemeConfigurable { }
extension NewBrewViewController: ThemeConfigurationContainer { }

final class NewBrewViewController: UIViewController {
	fileprivate let disposeBag = DisposeBag()
	fileprivate let keyboardManager = KeyboardManager()

	fileprivate lazy var closeBarButtonItem: UIBarButtonItem = {
		let buttonItem = UIBarButtonItem(image: UIImage(asset: .Ic_close)!, style: .plain, target: nil, action: nil)
		buttonItem.rx.tap.subscribe(onNext: self.close).addDisposableTo(self.disposeBag)
		return buttonItem
	}()
	fileprivate lazy var newBrewView = NewBrewView(frame: .zero)

	fileprivate var navigationBar: NewBrewNavigationBar {
		return newBrewView.navigationBar
	}
	fileprivate var progressView: NewBrewProgressView {
		return newBrewView.progressView
	}
	fileprivate var collectionView: UICollectionView {
		return newBrewView.collectionView
	}

	fileprivate(set) var currentPageIndex = 0 {
		didSet {
			guard isViewLoaded else { return }
			progressView.selectIconAtIndex(currentPageIndex)
		}
	}

	let viewModel: NewBrewViewModelType
	let metrics: ScrollViewPageMetricsType
	var themeConfiguration: ThemeConfiguration?

	let hideViewControllerSwitchingToHistorySubject = PublishSubject<Bool>()

	init(viewModel: NewBrewViewModelType, metrics: ScrollViewPageMetricsType, themeConfiguration: ThemeConfiguration? = nil) {
		self.viewModel = viewModel
		self.metrics = metrics
		self.themeConfiguration = themeConfiguration
        super.init(nibName: nil, bundle: nil)
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func loadView() {
		view = newBrewView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.newBrewItemTitle)
        newBrewView.configure(with: themeConfiguration)
		collectionView.delegate = self
        viewModel.configure(with: collectionView)

		navigationItem.leftBarButtonItem = closeBarButtonItem
		navigationBar.alpha = 0

		_ = viewModel.failedToCreateNewBrewSubject.subscribe(onNext: {
			XCGLogger.error("Failed to create new brew = \($0)")
		})
		_ = viewModel.reloadDataAnimatedSubject.subscribe(onNext: reloadData)

		_ = navigationBar.previousButton.rx.tap.bindNext(previousStep)
		_ = navigationBar.nextButton.rx.tap.bindNext(nextStep)

		keyboardManager
			.keyboardInfoChange
			.debounce(0.01, scheduler: MainScheduler.instance)
			.subscribe(onNext: newBrewView.handleKeyboardStateChange)
			.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure(with: themeConfiguration)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.newBrew)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDoneBarButtonItemIfNeeded(collectionView)
        setCurrentViewController(collectionView)
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		childViewControllers
			.filter { $0 is Activable }
			.map { $0 as! Activable }
			.filter { $0.active }
			.first?
			.deactivate()
	}
    
    fileprivate func perform(_ observable: Observable<Void>, isSuccessfullyFinished: Bool) {
        observable
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onCompleted: {
                [weak self] in
                self?.hideViewControllerSwitchingToHistorySubject.onNext(isSuccessfullyFinished)
            })
            .addDisposableTo(disposeBag)
    }

    private func reloadData(_ animated: Bool) {
        collectionView.reloadData()
        progressView.configureWithIcons(viewModel.progressIcons)
        progressView.selectIconAtIndex(0)
        progressView.show(animated: animated)
        navigationBar.show(animated: animated)
        navigationBar.hidePreviousArrow(animated: animated)
    }
}

extension NewBrewViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let childViewController = viewModel.stepViewController(for: indexPath)
		addChildViewController(childViewController)
		childViewController.didMove(toParentViewController: self)
		(cell as? NewBrewCollectionViewCell)?.configure(with: themeConfiguration)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let childViewController = viewModel.stepViewController(for: indexPath)
        childViewController.removeFromParentViewController()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndex(for: scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
	}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndex(for: scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
    }

	// MARK: Helpers

	fileprivate func setDoneBarButtonItemIfNeeded(_ scrollView: UIScrollView) {
		if metrics.isLastPage(of: scrollView) {
			let barButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_done), style: .plain, target: self, action: #selector(done))
			navigationItem.setRightBarButton(barButtonItem, animated: true)
		} else {
            let barButtonItem = UIBarButtonItem(image: viewModel.methodImage, style: .plain, target: nil, action: nil)
            barButtonItem.isEnabled = false
			navigationItem.setRightBarButton(barButtonItem, animated: false)
		}
	}
    
    private func disableProgressViewIfNeeded(_ scrollView: UIScrollView) {
        if metrics.isLastPage(of: scrollView) {
            progressView.disable()
        }
    }

	fileprivate func setCurrentViewController(_ scrollView: UIScrollView) {
		let currentIndex = metrics.currentPageIndex(for: scrollView)
        if let activeViewController = viewModel.setActiveViewController(at: currentIndex) {
			title = activeViewController.title ?? viewModel.methodTitle
		} else {
			title = viewModel.methodTitle
		}
	}
}

// MARK: Navigation

extension NewBrewViewController {
	func close() {
        perform(viewModel.cleanUp(), isSuccessfullyFinished: false)
	}

	func done() {
        perform(viewModel.finishBrew(), isSuccessfullyFinished: true)
    }
    
    func updateNavigationArrows() {
        if metrics.isFirstPage(of: collectionView) {
            navigationBar.showNextArrow()
            navigationBar.hidePreviousArrow()
        } else if metrics.isLastPage(of: collectionView) {
            navigationBar.showPreviousArrow()
            navigationBar.hideNextArrow()
        } else {
            navigationBar.showPreviousArrow()
            navigationBar.showNextArrow()
        }
    }

	func previousStep() {
        collectionView.scrollVerticallyToPageAtIndex(currentPageIndex - 1)
	}

	func nextStep() {
        collectionView.scrollVerticallyToPageAtIndex(currentPageIndex + 1)
	}
}
