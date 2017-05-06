//
// Created by Maciej Oczko on 17.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UIButton {
    func configure(with theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        titleLabel?.font = theme.defaultFontWithSize(titleLabel?.font.pointSize ?? 0)
        tintColor = theme.lightTintColor
    }
}
