//
//  GrindSizeViewModel.swift
//  Brewer
//
//  Created by Maciej Oczko on 19.03.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum GrindSizeUnit: Int32 {
	case Slider
	case Numeric
}

enum GrindSizeSliderValue: Double {
	case ExtraFine = 1.0
	case Fine = 2.0
	case Medium = 3.0
	case Coarse = 4.0
}

extension GrindSizeSliderValue: CustomStringConvertible {
	var description: String {
		switch self {
		case .ExtraFine: return tr(.GrindSizeLevelExtraFine)
		case .Fine: return tr(.GrindSizeLevelFine)
		case .Medium: return tr(.GrindSizeLevelMedium)
        case .Coarse: return tr(.GrindSizeLevelCoarse)
		}
	}
}

protocol GringSizeViewModelType {
	var sliderMinimumValue: Float { get }
	var sliderMaximumValue: Float { get }
	var sliderValue: Variable<Float> { get }
	var numericValue: Variable<String> { get }
    var inputTransformer: NumericalInputTransformerType { get }
    var isSliderVisible: Bool { get set }
    var informativeText: String { get }
}

final class GringSizeViewModel: GringSizeViewModelType {
	private let disposeBag = DisposeBag()
    
    enum Keys: String {
        case GrindSizeSliderVisibility = "GrindSizeSliderVisibilitySetting"
    }

    let inputTransformer = InputTransformer.numberTransformer()
	let brewModelController: BrewModelControllerType
    let keyValueStore: KeyValueStoreType

	private(set) var sliderValue = Variable<Float>(0.0)
	private(set) var numericValue = Variable<String>("")
    
    var informativeText: String {
        return tr(.GrindSizeInformativeText)
    }
    
    var isSliderVisible: Bool {
        set {
            keyValueStore.setObject(NSNumber(bool: newValue), forKey: Keys.GrindSizeSliderVisibility.rawValue)
        }
        get {
            if let visibilitySetting = keyValueStore.objectForKey(Keys.GrindSizeSliderVisibility.rawValue) as? NSNumber {
                return visibilitySetting.boolValue
            }
            return true
        }
    }

	var sliderMinimumValue: Float { return Float(GrindSizeSliderValue.ExtraFine.rawValue) }
	var sliderMaximumValue: Float { return Float(GrindSizeSliderValue.Coarse.rawValue) }

	init(brewModelController: BrewModelControllerType, keyValueStore: KeyValueStoreType) {
		self.brewModelController = brewModelController
        self.keyValueStore = keyValueStore

		configureAttributeUpdates()
	}
    
    private func configureAttributeUpdates() {
        let sliderObservable = sliderValue
            .asObservable()
            .map { (Double(round($0 * 4)), GrindSizeUnit.Slider.rawValue) }
        
        let numericObservable = numericValue
            .asObservable()
            .filter { !$0.characters.isEmpty }
            .map { (Double($0)!, GrindSizeUnit.Numeric.rawValue) }
        
        let valueUnits = [sliderObservable, numericObservable]
            .toObservable()
            .merge()
        
        updateAttribute(valueUnits) {
            (valueUnitPair, attribute) in
            attribute.type = BrewAttributeType.GrindSize.intValue
            attribute.value = valueUnitPair.0
            attribute.unit = valueUnitPair.1
            return attribute
        }
    }

	private func updateAttribute<O: ObservableType>(source: O, resultSelector: (O.E, BrewAttribute) throws -> (BrewAttribute)) {
		let attributeObservable: Observable<BrewAttribute> = {
			if let attribute = brewModelController.currentBrew()?.brewAttributeForType(.GrindSize) {
				return Observable.just(attribute)
			} else {
				return brewModelController.createNewBrewAttribute(forType: .GrindSize)
			}
		}()

		Observable
			.combineLatest(source, attributeObservable, resultSelector: resultSelector)
			.subscribeNext { attribute in attribute.brew = self.brewModelController.currentBrew() }
			.addDisposableTo(disposeBag)
	}

}
