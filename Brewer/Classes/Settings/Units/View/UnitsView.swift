//
// Created by Maciej Oczko on 11.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class UnitsView: UIView {
	lazy var segmentedControl = UISegmentedControl(items: nil)
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.tableFooterView = UIView()
		return tableView
	}()
	fileprivate lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [self.segmentedControl, self.tableView])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 10
		return stackView
	}()

	init() {
		super.init(frame: .zero)
		addSubview(stackView)
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		tableView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
		}
		stackView.snp.makeConstraints {
			make in
			make.leading.trailing.bottom.equalToSuperview()
			make.top.equalToSuperview().offset(10)
		}
	}
}

extension UnitsView {
	func configure(with theme: ThemeConfiguration?) {
		super.configure(with: theme)
		stackView.configure(with: theme)
		segmentedControl.configure(with: theme)
		tableView.configure(with: theme)
	}
}
