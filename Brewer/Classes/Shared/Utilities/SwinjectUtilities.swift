//
// Created by Maciej Oczko on 07.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject

extension Resolvable where Self: PropertyRetrievable {

    func viewControllerForIdentifier<T where T: UIViewController>(identifier: String) -> T {
        let sb = SwinjectStoryboard.create(name: identifier, bundle: nil, container: self)
        return sb.instantiateViewControllerWithIdentifier(identifier) as! T
    }
}
