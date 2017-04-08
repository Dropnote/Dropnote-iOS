//
// Created by Maciej Oczko on 08.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class SliderView: UIView {
	lazy var leadingLabel = UILabel()
	lazy var trailingLabel = UILabel()
	lazy var slider = UISlider()

	init() {
		super.init(frame: .zero)
		addSubview(leadingLabel)
		addSubview(trailingLabel)
		addSubview(slider)
		configureConstraint()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraint() {
		slider.snp.makeConstraints {
			make in
			make.leading.equalToSuperview().offset(15)
			make.trailing.equalToSuperview().offset(-15)
			make.top.equalTo(leadingLabel.snp.bottom).offset(-10)
			make.bottom.equalToSuperview()
		}
		leadingLabel.snp.makeConstraints {
			make in
			make.leading.equalTo(slider.snp.leading)
			make.bottom.equalTo(slider.snp.top).offset(10)
			make.top.equalToSuperview()
		}
		trailingLabel.snp.makeConstraints {
			make in
			make.trailing.equalTo(slider.snp.trailing)
			make.bottom.equalTo(slider.snp.top).offset(10)
			make.top.equalToSuperview()
		}
	}
}

extension SliderView {
	func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        leadingLabel.configure(with: theme)
        trailingLabel.configure(with: theme)
        slider.configure(with: theme)
	}

}
