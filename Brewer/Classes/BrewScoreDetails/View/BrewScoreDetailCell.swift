//
//  BrewScoreDetailCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 01.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BrewScoreDetailCell: UITableViewCell {
    fileprivate let disposeBag = DisposeBag()
    lazy var sliderView = SliderView(margin: 15, spacing: 5)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sliderView)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        sliderView.snp.makeConstraints {
            make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension BrewScoreDetailCell: PresentableConfigurable {
    typealias Presentable = ScoreCellPresentable
    
    func configure(with presentable: ScoreCellPresentable) {
        accessibilityHint = "Slider for \(presentable.title) value, current is \(presentable.value)"
        sliderView.leadingLabel.text = presentable.title
        sliderView.trailingLabel.text = presentable.value
        sliderView.slider.value = presentable.sliderValue.value
        sliderView.slider.rx.value.bindTo(presentable.sliderValue).addDisposableTo(disposeBag)
        sliderView.slider.rx.value.map { $0.format(".1") }.bindTo(sliderView.trailingLabel.rx.text).addDisposableTo(disposeBag)
    }
}

extension BrewScoreDetailCell {
    
    func configure(with theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
        sliderView.configure(with: theme)
        sliderView.leadingLabel.font = theme?.defaultFontWithSize(15)
        sliderView.trailingLabel.font = theme?.defaultFontWithSize(15)
    }
}
