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
    lazy var lightLabel = UILabel()
    lazy var strongLabel = UILabel()
    lazy var slider = UISlider()
    lazy var informativeLabel: InformativeLabel = InformativeLabel()

    init() {
        super.init(frame: .zero)
        addSubview(lightLabel)
        addSubview(strongLabel)
        addSubview(slider)
        addSubview(informativeLabel)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        slider.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(60)
        }
        lightLabel.snp.makeConstraints {
            make in
            make.leading.equalTo(slider.snp.leading)
            make.bottom.equalTo(slider.snp.top).offset(-10)
        }
        strongLabel.snp.makeConstraints {
            make in
            make.trailing.equalTo(slider.snp.trailing)
            make.bottom.equalTo(slider.snp.top).offset(-10)
        }
        informativeLabel.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(60)
        }
    }
}

extension TampingView {
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        slider.configureWithTheme(theme)
        [lightLabel, strongLabel].forEach {
            $0.configureWithTheme(theme)
        }
        informativeLabel.configureWithTheme(theme)
    }
}
