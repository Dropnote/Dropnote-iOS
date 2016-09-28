//
//  NumericalInputTextField.swift
//  Brewer
//
//  Created by Maciej Oczko on 02.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NumericalInputTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut)
            || action == #selector(paste)
            || action == #selector(delete)
            || action == #selector(makeTextWritingDirectionLeftToRight)
            || action == #selector(makeTextWritingDirectionRightToLeft)
            || action == #selector(toggleBoldface)
            || action == #selector(toggleItalics)
            || action == #selector(toggleUnderline) { return false }
        return true
    }
}
