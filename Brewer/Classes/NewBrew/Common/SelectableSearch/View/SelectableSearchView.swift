//
// Created by Maciej Oczko on 06.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class SelectableSearchView: UIStackView {
	lazy var inputTextField = UITextField()
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.tableFooterView = UIView()
		return tableView
	}()

	init() {
		super.init(frame: .zero)
        addArrangedSubview(inputTextField)
        addArrangedSubview(tableView)
		inputTextField.accessibilityLabel = "Type"
		axis = .vertical
		alignment = .center
		distribution = .fill
		spacing = 10.0
		configureConstraints()
	}
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		inputTextField.snp.makeConstraints {
			make in
			make.leading.equalToSuperview().offset(15)
			make.trailing.equalToSuperview().offset(-15)
			make.height.equalTo(50)
		}
		tableView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
		}
	}
}

extension SelectableSearchView {
    
	func configure(with theme: ThemeConfiguration?) {
        super.configure(with:theme)
        tableView.configure(with: theme)
        inputTextField.configure(with: theme)
	}
}
