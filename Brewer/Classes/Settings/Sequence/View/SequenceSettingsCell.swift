//
//  SequenceSettingsCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 07.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class SequenceSettingsCell: UITableViewCell {
    var themeBackgroundColor: UIColor?
    var themeSelectedBackgroundColor: UIColor? {
        didSet {
            selectedBackgroundView = .viewWithBackgroundColor(themeSelectedBackgroundColor)
        }
    }
    
    override var selected: Bool {
        set(newValue) {
            super.selected = newValue
            backgroundColor = themeBackgroundColor
        }
        get {
            return super.selected
        }
    }
}

extension SequenceSettingsCell {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        themeBackgroundColor = theme?.lightColor
        themeSelectedBackgroundColor = theme?.lightTintColor.colorWithAlphaComponent(0.3)
        textLabel?.configureWithTheme(theme)
    }
}
