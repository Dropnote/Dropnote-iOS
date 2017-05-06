//
//  TampingView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class TampingView: UIView {
    lazy var sliderView: SliderView = SliderView()
    lazy var informativeLabel: InformativeLabel = InformativeLabel()

    init() {
        super.init(frame: .zero)
        addSubview(sliderView)
        addSubview(informativeLabel)
        sliderView.leadingLabel.text = tr(.tampingStrengthLight)
        sliderView.trailingLabel.text = tr(.tampingStrengthStrong)
        sliderView.slider.minimumValue = 0
        sliderView.slider.maximumValue = 1
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        sliderView.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(45)
        }
        informativeLabel.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sliderView.snp.bottom).offset(60)
        }
    }
}

extension TampingView {

    func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        sliderView.configure(with: theme)
        informativeLabel.configure(with: theme)
    }
}
