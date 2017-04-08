//
//  MethodPickerCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 12.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class MethodPickerCell: UITableViewCell, Highlightable {
    fileprivate lazy var iconImageView = UIImageView(image: nil)
    fileprivate lazy var titleLabel = UILabel()
    
    var normalColor: UIColor?
    var highlightColor: UIColor?

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            highlight(views: [self], highlighted: isHighlighted)
        }
    }

    private func configureConstraints() {
        iconImageView.snp.makeConstraints {
            make in
            make.width.height.equalTo(58)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            make in
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
    }
}

extension MethodPickerCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: TitleImagePresentable) {
        accessibilityHint = "Selects \(presentable.title) method"
        titleLabel.text = presentable.title
        iconImageView.image = presentable.image
    }
}

extension MethodPickerCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        titleLabel.configureWithTheme(theme)
        titleLabel.backgroundColor = UIColor.clear
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
