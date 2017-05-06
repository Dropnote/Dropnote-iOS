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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        textLabel?.configure(with: theme)
        textLabel?.font = theme?.defaultFontWithSize(16)
        detailTextLabel?.configure(with: theme)
        detailTextLabel?.font = theme?.defaultFontWithSize(11)
        normalColor = theme?.lightColor
        highlightColor = highlightColor(for: theme)
    }
}
