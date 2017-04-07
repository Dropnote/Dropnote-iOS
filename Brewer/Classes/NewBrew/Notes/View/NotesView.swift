//
// Created by Maciej Oczko on 07.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class NotesView: UIView {
	lazy var textView = UITextView(frame: .zero, textContainer: nil)

	init() {
		super.init(frame: .zero)
		addSubview(textView)
		configureConstraints()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	private func configureConstraints() {
		textView.snp.makeConstraints {
			make in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.bottom.equalTo(self.snp.bottomMargin)
			make.top.equalToSuperview().offset(10)
		}
	}
}

extension NotesView {
	func configureWithTheme(_ theme: ThemeConfiguration?) {
		configureWithTheme(theme)
		textView.configureWithTheme(theme)
	}
}
