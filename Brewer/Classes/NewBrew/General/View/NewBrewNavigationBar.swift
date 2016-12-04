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
    
    func hide(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 0
        }) 
    }
    
    func show(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1
        }) 
    }
    
    func hideNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 0
        }) 
    }
    
    func showNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 1
        }) 
    }
    
    func hidePreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 0
        }) 
    }
    
    func showPreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 1
        }) 
    }
}

extension NewBrewNavigationBar {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = theme?.lightColor
    }
}
