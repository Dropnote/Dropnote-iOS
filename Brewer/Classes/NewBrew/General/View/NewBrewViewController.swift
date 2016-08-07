//
// Created by Maciej Oczko on 20.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Box
import XCGLogger

extension NewBrewViewController: ThemeConfigurable { }
extension NewBrewViewController: ThemeConfigurationContainer { }

final class NewBrewViewController: UIViewController {
	private let disposeBag = DisposeBag()
	private let keyboardManager = KeyboardManager()
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem! {
        didSet {
            doneBarButtonItem.accessibilityLabel = "Done"
            doneBarButtonItem.accessibilityHint = "Finishes brew session"
        }
    }
	@IBOutlet weak var navigationBar: NewBrewNavigationBar!
	@IBOutlet weak var progressView: NewBrewProgressView!

	var themeConfiguration: ThemeConfiguration?

    private(set) var currentPageIndex = 0 {
        didSet {
            guard let progressView = progressView else { return }
            progressView.selectIconAtIndex(currentPageIndex)
        }
    }
    
	var metrics: ScrollViewPageMetricsType!
	var viewModel: NewBrewViewModelType! {
		didSet {
            _ = viewModel.failedToCreateNewBrewSubject.subscribeNext {
                XCGLogger.error("Failed to create new brew = \($0)")
            }
            _ = viewModel.reloadDataAnimatedSubject.subscribeNext(reloadData)
		}
	}

	let hideViewControllerSwitchingToHistorySubject = PublishSubject<Bool>()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = tr(.NewBrewItemTitle)
		configureWithTheme(themeConfiguration)
		collectionView.delegate = self
		collectionView.scrollEnabled = true
        collectionView.delaysContentTouches = false
		viewModel.configureWithCollectionView(collectionView)

        configureProgressView()
		configureNavigationBar()

		keyboardManager
			.keyboardInfoChange
			.debounce(0.01, scheduler: MainScheduler.instance)
			.subscribeNext(handleKeyboardStateChange)
			.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.sharedInstance.trackScreen(withTitle: AppScreen.newBrew)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setCurrentViewController(collectionView)
    }

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		childViewControllers
			.filter { $0 is Activable }
			.map { $0 as! Activable }
			.filter { $0.active }
			.first?
			.deactivate()
	}

	@IBAction func close(sender: AnyObject) {
        perform(viewModel.cleanUp(), isSuccessfullyFinished: false)		
	}

	func done() {
        perform(viewModel.finishBrew(), isSuccessfullyFinished: true)
    }
    
    private func perform(observable: Observable<Void>, isSuccessfullyFinished: Bool) {
        observable.observeOn(MainScheduler.asyncInstance).subscribeCompleted {
            [weak self] in
            self?.hideViewControllerSwitchingToHistorySubject.onNext(isSuccessfullyFinished)
        }.addDisposableTo(disposeBag)
    }

	private func configureNavigationBar() {
		navigationBar.configureWithTheme(themeConfiguration)
		navigationBar.alpha = 0
        navigationBar.previousButton.accessibilityLabel = "Previous Step"
        navigationBar.nextButton.accessibilityLabel = "Next Step"
		navigationBar.previousButton.addTarget(self, action: #selector(NewBrewViewController.previousStep), forControlEvents: .TouchUpInside)
		navigationBar.nextButton.addTarget(self, action: #selector(NewBrewViewController.nextStep), forControlEvents: .TouchUpInside)
	}
    
    private func configureProgressView() {
        progressView.configureWithTheme(themeConfiguration)        
        progressView.axis = .Horizontal
        progressView.distribution = .EqualSpacing
        progressView.alignment = .Center
    }
    
    private func reloadData(animated: Bool) {
        collectionView.reloadData()
        progressView.configureWithIcons(viewModel.progressIcons)
        progressView.selectIconAtIndex(0)
        progressView.show(animated: animated)
        navigationBar.show(animated: animated)
        navigationBar.hidePreviousArrow(animated: animated)
    }
}

extension NewBrewViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		let childViewController = viewModel.stepViewController(forIndexPath: indexPath)
		addChildViewController(childViewController)
		childViewController.didMoveToParentViewController(self)
        
        cell.configureWithTheme(themeConfiguration)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let childViewController = viewModel.stepViewController(forIndexPath: indexPath)
        childViewController.removeFromParentViewController()
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndexForScrollView(scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
	}
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPageIndex = metrics.currentPageIndexForScrollView(scrollView)
        setCurrentViewController(scrollView)
        setDoneBarButtonItemIfNeeded(scrollView)
        disableProgressViewIfNeeded(scrollView)
        updateNavigationArrows()
    }

	// MARK: Helpers

	private func setDoneBarButtonItemIfNeeded(scrollView: UIScrollView) {
		if metrics.isLastPageOfScrollView(scrollView) {
			let barButtonItem = UIBarButtonItem(image: UIImage(asset: .Ic_done), style: .Plain, target: self, action: #selector(NewBrewViewController.done))
			navigationItem.setRightBarButtonItem(barButtonItem, animated: true)
		} else {
			navigationItem.setRightBarButtonItem(nil, animated: true)
		}
	}
    
    private func disableProgressViewIfNeeded(scrollView: UIScrollView) {
        if metrics.isLastPageOfScrollView(scrollView) {
            progressView.disable()
        }
    }

	private func setCurrentViewController(scrollView: UIScrollView) {
		let currentIndex = metrics.currentPageIndexForScrollView(scrollView)
		if let activeViewController = viewModel.setActiveViewControllerAtIndex(currentIndex) {
			title = activeViewController.title ?? tr(.NewBrewItemTitle)
		} else {
			title = tr(.NewBrewItemTitle)
		}
	}

	private func handleKeyboardStateChange(info: KeyboardInfo) {
		if info.state == .WillShow || info.state == .Visible {
			navigationBar.bottomConstraint.constant = info.endFrame.size.height
		} else {
			navigationBar.bottomConstraint.constant = 0.0
		}

		UIView.animateWithDuration(info.animationDuration, delay: 0.0, options: info.animationOptions, animations: {
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
}

// MARK: Navigation

extension NewBrewViewController {
    
    func updateNavigationArrows() {
        if metrics.isFirstPageOfScrollView(collectionView) {
            navigationBar.showNextArrow()
            navigationBar.hidePreviousArrow()
        } else if metrics.isLastPageOfScrollView(collectionView) {
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
