//
// Created by Maciej Oczko on 09.04.2017.
// Copyright (c) 2017 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UITableViewCell {
    func configure(with theme: ThemeConfiguration?) {
		selectionStyle = .none
		separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        guard let theme = theme else { return }
    }
}
