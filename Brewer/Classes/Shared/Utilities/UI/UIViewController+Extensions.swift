//
//  UIViewControllerExtensions.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {    
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    func enableSwipeToBack() {
        if let navigationController = navigationController {
            navigationController.interactivePopGestureRecognizer?.enabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
