//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewCollectionViewCell: UICollectionViewCell {
    var topInset: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .center
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var stepView: UIView? {
        willSet {
            stepView?.removeFromSuperview()
        }
        didSet {
            if let stepView = stepView {
                contentView.addSubview(stepView)
                setNeedsLayout()
            }
        }
    }

    override func layoutSubviews() {
        contentView.frame = bounds
        stepView?.frame = CGRect(x: 0, y: 0 + topInset, width: bounds.width, height: bounds.height - topInset)
    }
}
