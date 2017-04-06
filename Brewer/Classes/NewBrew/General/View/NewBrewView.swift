//
// Created by Maciej Oczko on 05.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class NewBrewView: UIView {
    lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
		collectionView.isScrollEnabled = true
		collectionView.delaysContentTouches = false
		return collectionView
	}()
	lazy var navigationBar = NewBrewNavigationBar()
	lazy var progressView = NewBrewProgressView()

	private weak var navigationBarBottomConstraint: NSLayoutConstraint?

	public override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(progressView)
		addSubview(collectionView)
		addSubview(navigationBar)
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		progressView.snp.makeConstraints {
			make in
			make.top.equalToSuperview()
			make.height.equalTo(44)
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
		}
		collectionView.snp.makeConstraints {
			make in
			make.top.equalTo(progressView.snp.bottom)
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
		navigationBar.snp.makeConstraints {
			make in
			make.height.equalTo(44)
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
		}
		let navigationBarBottomConstraint = NSLayoutConstraint(item: navigationBar,
		                                                       attribute: .bottom,
		                                                       relatedBy: .equal,
		                                                       toItem: self,
		                                                       attribute: .bottom,
		                                                       multiplier: 1,
		                                                       constant: 0)
        NSLayoutConstraint.activate([navigationBarBottomConstraint])
		self.navigationBarBottomConstraint = navigationBarBottomConstraint
	}

	func handleKeyboardStateChange(_ info: KeyboardInfo) {
		if info.state == .willShow || info.state == .visible {
			navigationBarBottomConstraint?.constant = info.endFrame.size.height + 10
		} else {
			navigationBarBottomConstraint?.constant = 10.0
		}

		UIView.animate(withDuration: info.animationDuration, delay: 0.0, options: info.animationOptions, animations: {
			self.layoutIfNeeded()
        }, completion: nil)
	}
}

extension NewBrewView {
	func configureWithTheme(_ theme: ThemeConfiguration?) {
		super.configureWithTheme(theme)
		collectionView.configureWithTheme(theme)
		progressView.configureWithTheme(theme)
		navigationBar.configureWithTheme(theme)
	}
}
