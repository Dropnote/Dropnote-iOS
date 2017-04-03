//
//  BrewCellScoreView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class BrewCellScoreView: UIView {
    fileprivate(set) lazy var scoreLabel = UILabel()
    fileprivate lazy var fillingView = UIView()

    var fillingFactor: Double = 0
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var fillingColor: UIColor = .white {
        didSet {
            fillingView.backgroundColor = fillingColor
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fillingView)
        addSubview(scoreLabel)
        clipsToBounds = true
        layer.borderWidth = 3
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureConstraints() {
        scoreLabel.snp.makeConstraints {
            make in
            make.center.equalToSuperview()
        }
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
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        scoreLabel.configureWithTheme(theme)
        scoreLabel.backgroundColor = UIColor.clear
    }
}
