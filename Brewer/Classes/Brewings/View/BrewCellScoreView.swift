//
//  BrewCellScoreView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class BrewCellScoreView: UIView {
    @IBOutlet weak var scoreLabel: UILabel!
    
    private let fillingView = UIView()
    var fillingFactor: Double = 0
    var borderColor: UIColor = .whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    var fillingColor: UIColor = .whiteColor() {
        didSet {
            fillingView.backgroundColor = fillingColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        layer.borderWidth = 3
        insertSubview(fillingView, atIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
        fillingView.frame = CGRect(
            x: 0,
            y: frame.height * CGFloat(1 - fillingFactor),
            width: frame.width,
            height: frame.height * CGFloat(fillingFactor)
        )
    }
}

extension BrewCellScoreView {
    
    func configureWithTheme(theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        scoreLabel.configureWithTheme(theme)
        scoreLabel.backgroundColor = UIColor.clearColor()
    }
}
