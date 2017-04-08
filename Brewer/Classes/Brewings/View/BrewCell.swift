//
// Created by Maciej Oczko on 20.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewCell: UITableViewCell, Highlightable {
    fileprivate lazy var createdAtLabel = UILabel()
    fileprivate lazy var coffeeLabel = UILabel()
    fileprivate lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.createdAtLabel, self.coffeeLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    fileprivate lazy var iconImageView = UIImageView()
    fileprivate lazy var scoreView = BrewCellScoreView(frame: .zero)

    var normalColor: UIColor?
    var highlightColor: UIColor?

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
        selectionStyle = .none

        contentView.addSubview(iconImageView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(scoreView)

        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWithViewModel(_ viewModel: BrewCellViewModelType) {
        accessibilityHint = "Shows brew details for \(viewModel.coffee)"
        createdAtLabel.text = viewModel.createdAt
        coffeeLabel.text = viewModel.coffee
        scoreView.scoreLabel.text = viewModel.score
        scoreView.borderColor = viewModel.methodColor
        scoreView.fillingColor = viewModel.methodLightColor
        scoreView.fillingFactor = viewModel.fillingFactor
        iconImageView.image = UIImage(asset: viewModel.methodImageName)
        scoreView.setNeedsLayout()
        scoreView.layoutIfNeeded()
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlight(views: [self, self.createdAtLabel, self.coffeeLabel], highlighted: isHighlighted)
        }
    }

    private func configureConstraints() {
        iconImageView.snp.makeConstraints {
            make in
            make.width.height.equalTo(58)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        labelsStackView.snp.makeConstraints {
            make in
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.scoreView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        scoreView.snp.makeConstraints {
            make in
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}

extension BrewCell {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
        scoreView.configureWithTheme(theme)
        [createdAtLabel, coffeeLabel].forEach {
            $0.configureWithTheme(theme)
        }
        coffeeLabel.font = theme?.mediumFontWithSize(coffeeLabel.font.pointSize)
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
