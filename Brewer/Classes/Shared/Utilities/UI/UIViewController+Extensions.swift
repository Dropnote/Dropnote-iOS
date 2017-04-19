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
    func setupDefaultBackBarButtonItemIfNeeded() {
        if navigationController != nil {
            navigationItem.setLeftBarButton(createDefaultBackBarButtonItem(), animated: false)
        }
    }

    func createDefaultBackBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(asset: .Ic_back), style: .plain, target: self, action: #selector(pop))
    }

    func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    func enableSwipeToBack() {
        if let navigationController = navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
