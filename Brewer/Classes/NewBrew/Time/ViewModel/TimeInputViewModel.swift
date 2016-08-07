//
// Created by Maciej Oczko on 18.03.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCGLogger

enum TimeUnit: Int {
    case Seconds
}

final class TimeInputViewModel: NumericalInputViewModelType {
    private let disposeBag = DisposeBag()

    var unit: String {
        return "m"
    }
    
    var informativeText: String {
        return tr(.TimeInformativeText)
    }
    
    var currentValue: String? = nil
    lazy var inputTransformer: NumericalInputTransformerType = InputTransformer.timeTransformer()

    let unitModelController: UnitsModelControllerType
    let brewModelController: BrewModelControllerType

    init(unitModelController: UnitsModelControllerType, brewModelController: BrewModelControllerType) {
        self.unitModelController = unitModelController
        self.brewModelController = brewModelController
    }

    func setInputValue(value: String) {
        guard let brew = brewModelController.currentBrew() else { return }

        let components = value.componentsSeparatedByString(":")
        let minutes = Int(components.first!)!
        let seconds = Int(components.last!)!
        let duration = NSTimeInterval(60 * minutes + seconds)

        brewModelController
            .createNewBrewAttribute(forType: .Time)
            .subscribeNext {
                attribute in
                
                attribute.type = BrewAttributeType.Time.intValue
                attribute.value = duration
                attribute.unit = Int32(TimeUnit.Seconds.rawValue)
                attribute.brew = brew
                
            }
            .addDisposableTo(disposeBag)
    }
}
