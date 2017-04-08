//
//  BrewNotesCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewNotesCell: UITableViewCell, Highlightable {
    lazy var titleLabel: UILabel = UILabel()
    lazy var valueLabel: UILabel = UILabel()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.valueLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlightViews([self, titleLabel, valueLabel], highlighted: isHighlighted)
        }
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        valueLabel.numberOfLines = 0
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        stackView.snp.makeConstraints {
            make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

extension BrewNotesCell: PresentableConfigurable {
    
    func configureWithPresentable(_ presentable: TitleValuePresentable) {
        accessibilityHint = "Represents notes taken during brew session"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
    }
}

extension BrewNotesCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        [titleLabel, valueLabel].forEach {
            $0.configureWithTheme(theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
