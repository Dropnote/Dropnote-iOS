//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

extension BrewAttributeType {
    func defaultPosition(forMethod method: BrewMethod) -> Int {
        switch self {
        case .CoffeeWeight: return 0
        case .GrindSize: return 1
        case .TampStrength: return 2
        case .WaterTemperature: return 3
        case .WaterWeight: return 4
        case .Time: return 5
        case .Notes: return 6
        }
    }

    func defaultEnabled(forMethod method: BrewMethod) -> Bool {
        switch self {
        case .CoffeeWeight, .GrindSize, .WaterTemperature, .WaterWeight, .Time, .Notes:
            return true
        case .TampStrength:
            switch method {
            case .CoffeeMachine: return true
            default: return false
            }
        }
    }
}
