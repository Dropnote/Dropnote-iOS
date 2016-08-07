//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewingsSortingOptionCell: UITableViewCell {
    private var normalColor: UIColor?
    private var selectedColor: UIColor?
    
    override var accessoryType: UITableViewCellAccessoryType {
        didSet {
            adjustImageTintColorDependingOnSelection()
        }
    }
    
    private func adjustImageTintColorDependingOnSelection() {
        if case .Checkmark = accessoryType {
            imageView?.tintColor = selectedColor
        } else {
            imageView?.tintColor = normalColor
        }
    }
}

extension BrewingsSortingOptionCell: PresentableConfigurable {

    func configureWithPresentable(presentable: TitleImagePresentable) {
        accessibilityHint = "Represents sorting \(presentable.title)"
        textLabel?.text = presentable.title
        imageView?.image = presentable.image.imageWithRenderingMode(.AlwaysTemplate)
    }
}

extension BrewingsSortingOptionCell {

    func configureWithTheme(theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        normalColor = theme?.darkColor
        selectedColor = theme?.lightTintColor
        textLabel?.configureWithTheme(theme)
        imageView?.configureWithTheme(theme)
        
        adjustImageTintColorDependingOnSelection()
    }
}
