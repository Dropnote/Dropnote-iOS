//
//  SettingsCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCell: UITableViewCell, Highlightable {
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            highlight(views: [self, textLabel!], highlighted: isHighlighted)
        }
    }
}

extension SettingsCell: PresentableConfigurable {
    typealias Presentable = TitlePresentable
    
    func configure(with presentable: TitlePresentable) {
        accessibilityHint = "Opens \(presentable.title)"
        textLabel?.text = presentable.title
    }
}

extension SettingsCell {
    
    func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        [textLabel!, detailTextLabel!].forEach {
            $0.configure(with: theme)
        }
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
