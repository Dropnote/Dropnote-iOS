//
//  BrewScoreDetailsHeaderView.swift
//  Brewer
//
//  Created by Maciej Oczko on 03.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewScoreDetailsHeaderView: UIView {
    lazy var titleLabel: UILabel = UILabel()
    lazy var valueLabel: UILabel = UILabel()

    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)
        addSubview(valueLabel)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }
}

extension BrewScoreDetailsHeaderView {
    
    func configure(with theme: ThemeConfiguration?) {
        backgroundColor = theme?.darkColor
        [titleLabel, valueLabel].forEach {
            $0.configure(with: theme)
            $0.backgroundColor = theme?.darkColor
            $0.textColor = theme?.lightColor
        }
    }
}
