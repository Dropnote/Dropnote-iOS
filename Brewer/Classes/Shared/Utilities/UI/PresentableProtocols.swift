//
//  TitlePresentable.swift
//  Brewer
//
//  Created by Maciej Oczko on 17.04.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TitlePresentable {
    var title: String { get }
}

protocol ValuePresentable {
    var value: String { get }
}

protocol SliderPresentable {
    var sliderValue: Variable<Float> { get }
}

protocol ImagePresentable {
    var image: UIImage { get }
}

protocol PresentableConfigurable {
    associatedtype Presentable
    func configureWithPresentable(presentable: Presentable)
}

// MARK: Title Value

typealias TitleValuePresentable = protocol<TitlePresentable, ValuePresentable>

// MARK: Title Image

typealias TitleImagePresentable = protocol<TitlePresentable, ImagePresentable>

// MARK: Title Value Slider

typealias ScoreCellPresentable = protocol<TitlePresentable, ValuePresentable, SliderPresentable>
