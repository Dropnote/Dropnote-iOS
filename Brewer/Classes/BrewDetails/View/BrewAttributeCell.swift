//
//  BrewAttributeCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 09.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewAttributeCell: UITableViewCell, Highlightable {
    lazy var titleLabel: UILabel = UILabel()
    lazy var valueLabel: UILabel = UILabel()
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlight(views: [self, titleLabel, valueLabel], highlighted: isHighlighted)
        }
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        titleLabel.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        valueLabel.snp.makeConstraints {
            make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-60)
            make.width.greaterThanOrEqualTo(80)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension BrewAttributeCell: PresentableConfigurable {
    typealias Presentable = TitleValuePresentable
    
    func configure(with presentable: TitleValuePresentable) {
        accessibilityHint = "Represents \(presentable.title) attribute with value \(presentable.value)"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
    }
}

extension BrewAttributeCell {
    
    func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        [titleLabel, valueLabel].forEach {
            $0.configure(with: theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
