//
//  FinalScoreCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 09.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class FinalScoreCell: UITableViewCell, Highlightable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlight(views: [self, titleLabel, valueLabel], highlighted: isHighlighted)
        }
    }
}

extension FinalScoreCell: PresentableConfigurable {
    typealias Presentable = TitleValuePresentable
    
    func configure(with presentable: TitleValuePresentable) {
        accessibilityHint = "Represents brew score that equals \(presentable.value)"
        titleLabel.text = presentable.title
        valueLabel.text = presentable.value
    }
}

extension FinalScoreCell {
    
    func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        [titleLabel, valueLabel].forEach {
            $0!.configure(with: theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
