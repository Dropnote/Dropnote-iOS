//
//  BrewingSortingOption+SortDescriptor.swift
//  Brewer
//
//  Created by Maciej Oczko on 20.06.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import CoreData

extension BrewingSortingOption {
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .DateDescending: return NSSortDescriptor(key: "created", ascending: false)
        case .DateAscending: return NSSortDescriptor(key: "created", ascending: true)
        case .ScoreDescending: return NSSortDescriptor(key: "score", ascending: false)
        case .ScoreAscending: return NSSortDescriptor(key: "score", ascending: true)
        }
    }
}
