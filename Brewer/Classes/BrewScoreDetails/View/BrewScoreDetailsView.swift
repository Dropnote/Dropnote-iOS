//
// Created by Maciej Oczko on 08.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewScoreDetailsView: UIView {
	lazy var headerView = BrewScoreDetailsHeaderView()
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.tableFooterView = UIView()
		tableView.rowHeight = 100
		return tableView
	}()

	init() {
		super.init(frame: .zero)
		addSubview(headerView)
		addSubview(tableView)
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		headerView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
			make.top.equalToSuperview()
			make.height.equalTo(64)
		}
		tableView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
			make.top.equalTo(headerView.snp.bottom)
		}
	}
}

extension BrewScoreDetailsView {

	func configure(with theme: ThemeConfiguration?) {
		super.configure(with: theme)
		tableView.configure(with: theme)
		headerView.configure(with: theme)
	}
}
