//
//  NewBrewProgressView.swift
//  Brewer
//
//  Created by Maciej Oczko on 22.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewProgressView: UIStackView {
    private var selectedIconColor = UIColor.whiteColor()
    
    @IBOutlet weak var backgroundView: UIView!
    
    func selectIconAtIndex(index: Int) {
        guard arrangedSubviews.count > index else { return }
        guard index >= 0 else { return }
        for (idx, view) in arrangedSubviews.enumerate() {
            if idx != index {
                view.tintColor = tintColor
            } else {
                view.tintColor = selectedIconColor
            }
        }
    }
    
    func configureWithIcons(icons: [Asset]) {
        subviews.forEach { $0.removeFromSuperview() }
        for icon in icons {
            let iconImage = UIImage(asset: icon)?.imageWithRenderingMode(.AlwaysTemplate)
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = tintColor
            addArrangedSubview(iconImageView)
        }
    }
    
    func show(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.alpha = 1
            self.backgroundView.alpha = 1
        }
    }
    
    func hide(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.alpha = 0
            self.backgroundView.alpha = 0
        }
    }
    
    func enable(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.arrangedSubviews.forEach(self.enableIconView)
        }
    }
    
    func disable(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.arrangedSubviews.forEach(self.disableIconView)
        }
    }
    
    private func enableIconView(view: UIView) {
        if view.tintColor == UIColor.lightGrayColor() {
            view.tintColor = tintColor
        }        
    }
    
    private func disableIconView(view: UIView) {
        view.tintColor = UIColor.lightGrayColor()
    }
}

extension NewBrewProgressView {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundView.backgroundColor = theme.lightColor
        tintColor = UIColor.lightGrayColor()
        selectedIconColor = theme.darkTintColor
    }
}
