//
// Created by Maciej Oczko on 19.06.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum BrewingSortingOption {
    case DateAscending
    case DateDescending
    case ScoreAscending
    case ScoreDescending

    static let allValues: [BrewingSortingOption] = [.DateAscending, .DateDescending, .ScoreAscending, .ScoreDescending]
}
