//
//  NewBrewNavigationBar.swift
//  Brewer
//
//  Created by Maciej Oczko on 14.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewNavigationBar: UIView {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    func hide(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.alpha = 0
        }
    }
    
    func show(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.alpha = 1
        }
    }
    
    func hideNextArrow(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.nextButton.alpha = 0
        }
    }
    
    func showNextArrow(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.nextButton.alpha = 1
        }
    }
    
    func hidePreviousArrow(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.previousButton.alpha = 0
        }
    }
    
    func showPreviousArrow(animated animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.3 : 0) {
            self.previousButton.alpha = 1
        }
    }
}

extension NewBrewNavigationBar {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
    }
}
