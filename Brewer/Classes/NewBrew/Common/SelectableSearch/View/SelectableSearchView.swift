//
// Created by Maciej Oczko on 06.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class SelectableSearchView: UIView {
	lazy var inputTextField: UITextField = UITextField()
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.tableFooterView = UIView()
		return tableView
	}()
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [self.inputTextField, self.tableView])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 10.0
		return stackView
	}()

	init() {
		super.init(frame: .zero)
		inputTextField.accessibilityLabel = "Type"
		addSubview(stackView)
		configureConstraints()
	}
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		stackView.snp.makeConstraints {
			make in
			make.leading.top.trailing.bottom.equalToSuperview()
		}
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
		inputTextField.font = theme?.defaultFontWithSize(14)
	}
}
