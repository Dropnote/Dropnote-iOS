//
//  InformativeLabel.swift
//  Brewer
//
//  Created by Maciej Oczko on 21.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class InformativeLabel: UILabel {
    
}

extension InformativeLabel {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        textColor = UIColor.lightGrayColor()
        font = theme?.defaultFontWithSize(12)
    }
}
