//
//  MethodPickerCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 12.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class MethodPickerCell: UITableViewCell, Highlightable {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var normalColor: UIColor?
    var highlightColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryView = UIImageView(image: UIImage(asset: .Ic_arrow))
    }
    
    override var highlighted: Bool {
        didSet {
            highlightViews([self], highlighted: highlighted)
        }
    }
}

extension MethodPickerCell: PresentableConfigurable {
    
    func configureWithPresentable(presentable: TitleImagePresentable) {
        accessibilityHint = "Selects \(presentable.title) method"
        titleLabel.text = presentable.title
        iconImageView.image = presentable.image
    }
}

extension MethodPickerCell {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        titleLabel.configureWithTheme(theme)
        titleLabel.backgroundColor = UIColor.clearColor()
        normalColor = theme?.lightColor
        highlightColor = highlightColorForTheme(theme)
    }
}
