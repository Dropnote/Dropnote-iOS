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
	lazy var slider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 0
		slider.maximumValue = 10
		return slider
	}()

	let margin: CGFloat
	let spacing: CGFloat

	init(margin: CGFloat = 15, spacing: CGFloat = 10) {
		self.margin = margin
		self.spacing = spacing
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
			make.leading.equalToSuperview().offset(1.5 * margin)
			make.trailing.equalToSuperview().offset(-1.5 * margin)
			make.top.equalTo(leadingLabel.snp.bottom).offset(spacing)
			make.bottom.equalToSuperview()
		}
		leadingLabel.snp.makeConstraints {
			make in
			make.leading.equalTo(slider.snp.leading)
			make.bottom.equalTo(slider.snp.top).offset(-spacing)
			make.top.equalToSuperview()
		}
		trailingLabel.snp.makeConstraints {
			make in
			make.trailing.equalTo(slider.snp.trailing)
			make.bottom.equalTo(slider.snp.top).offset(-spacing)
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
