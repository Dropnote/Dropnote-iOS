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
    
    override var isSelected: Bool {
        set(newValue) {
            super.isSelected = newValue
            backgroundColor = themeBackgroundColor
        }
        get {
            return super.isSelected
        }
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shouldIndentWhileEditing = true
        accessoryType = .none
        editingAccessoryType = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SequenceSettingsCell {
    
    func configure(with theme: ThemeConfiguration?) {
        super.configure(with: theme)
        themeBackgroundColor = theme?.lightColor
        themeSelectedBackgroundColor = theme?.lightTintColor.withAlphaComponent(0.3)
        textLabel?.configure(with: theme)
        textLabel?.backgroundColor = UIColor.clear
    }
}
