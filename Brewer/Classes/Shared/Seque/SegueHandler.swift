//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier else {
            fatalError("Segue identifier doesn't exist")
        }
        guard let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Unknown segue: \(segue))")
        }
        return segueIdentifier
    }

    func performSegue(segueIdentifier: SegueIdentifier) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: nil)
    }

    func performSegue(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }

}
