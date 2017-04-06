//
//  NewBrewNavigationBar.swift
//  Brewer
//
//  Created by Maciej Oczko on 14.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class NewBrewNavigationBar: UIView {
    lazy var previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(asset: .Ic_previous), for: .normal)
        button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = false
        button.layer.cornerRadius = 22
        button.accessibilityLabel = "Previous Step"
        return button
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(asset: .Ic_next), for: .normal)
        button.imageView?.contentMode = .center
        button.imageView?.clipsToBounds = false        
        button.layer.cornerRadius = 22
        button.accessibilityLabel = "Next Step"
        return button
    }()

    convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previousButton)
        addSubview(nextButton)
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        previousButton.snp.makeConstraints {
            make in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        nextButton.snp.makeConstraints {
            make in
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    func hide(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 0
        })
    }

    func show(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1
        }) 
    }
    
    func hideNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 0
        }) 
    }
    
    func showNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 1
        }) 
    }
    
    func hidePreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 0
        }) 
    }
    
    func showPreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 1
        }) 
    }
}

extension NewBrewNavigationBar {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = UIColor.clear
        nextButton.backgroundColor = theme?.lightColor
        nextButton.layer.borderColor = theme?.lightTintColor.cgColor
        nextButton.layer.borderWidth = 0.5
        previousButton.backgroundColor = theme?.lightColor
        previousButton.layer.borderColor = theme?.lightTintColor.cgColor
        previousButton.layer.borderWidth = 0.5
    }
}
