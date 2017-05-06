//
// Created by Maciej Oczko on 07.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class NumericalInputView: UIView {
	lazy var inputTextField: NumericalInputTextField = {
		let textField = NumericalInputTextField()
		textField.accessibilityLabel = "Type"
		textField.tintColor = .clear
		textField.textAlignment = .center
        textField.keyboardType = .numberPad
		return textField
	}()
    lazy var informativeLabel: InformativeLabel = InformativeLabel()

	init() {
		super.init(frame: .zero)
		addSubview(inputTextField)
		addSubview(informativeLabel)
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		inputTextField.snp.makeConstraints {
			make in
			make.height.equalTo(80)
			make.leading.equalToSuperview().offset(50)
			make.trailing.equalToSuperview().offset(-50)
			make.top.equalToSuperview().offset(70)
		}
		informativeLabel.snp.makeConstraints {
			make in
			make.centerX.equalToSuperview()
			make.top.equalTo(self.inputTextField.snp.bottom).offset(60)
		}
	}
}

extension NumericalInputView {
    
	func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        inputTextField.configure(with: theme)
		inputTextField.font = theme?.defaultFontWithSize(50)
        informativeLabel.configure(with: theme)
		informativeLabel.font = theme?.defaultFontWithSize(14)
	}
}
