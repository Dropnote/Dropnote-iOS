//
//  Highlightable.swift
//  Brewer
//
//  Created by Maciej Oczko on 28.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol Highlightable {
    var normalColor: UIColor? { get set }
    var highlightColor: UIColor? { get set }
    
    func highlightColor(for theme: ThemeConfiguration?) -> UIColor?
    func highlight(views: [UIView], highlighted: Bool)
}

extension Highlightable {
 
    func highlightColor(for theme: ThemeConfiguration?) -> UIColor? {
        return theme?.lightTintColor.withAlphaComponent(0.2)
    }
    
    func highlight(views: [UIView], highlighted: Bool) {
        for view in views {
            var highlightColor = self.highlightColor
            if view is UILabel {
                highlightColor = UIColor.clear
            }
            view.backgroundColor = highlighted ? highlightColor : normalColor
        }
    }
}
