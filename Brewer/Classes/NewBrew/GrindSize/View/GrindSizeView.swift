//
// Created by Maciej Oczko on 08.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class GrindSizeView: UIView {
	lazy var informativeLabel: InformativeLabel = InformativeLabel()
	lazy var sliderView: SliderView = SliderView()
	lazy var textField: NumericalInputTextField = NumericalInputTextField()
	lazy var switchButton: UIButton = UIButton(type: .custom)

	init() {
		super.init(frame: .zero)
		addSubview(textField)
		addSubview(sliderView)
		addSubview(switchButton)
		addSubview(informativeLabel)
		sliderView.leadingLabel.text = tr(.grindSizeLevelExtraFine)
		sliderView.trailingLabel.text = tr(.grindSizeLevelCoarse)
		sliderView.slider.isContinuous = false
		textField.tintColor = UIColor.clear
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		sliderView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalToSuperview().offset(-45)
		}
		textField.snp.makeConstraints {
			make in
			make.height.equalTo(80)
			make.leading.equalToSuperview().offset(50)
			make.trailing.equalToSuperview().offset(-50)
			make.top.equalToSuperview().offset(70)
		}
		switchButton.snp.makeConstraints {
			make in
			make.top.equalTo(sliderView.snp.bottom).offset(40)
			make.leading.greaterThanOrEqualTo(self.snp.leading).offset(20)
			make.trailing.greaterThanOrEqualTo(self.snp.trailing).offset(-20)
		}
		informativeLabel.snp.makeConstraints {
			make in
			make.centerX.equalToSuperview()
			make.top.equalTo(switchButton.snp.bottom).offset(30)
		}
	}
}

extension GrindSizeView {
	func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        sliderView.configure(with: theme)
        textField.configure(with: theme)
        informativeLabel.configure(with: theme)
	}
}
