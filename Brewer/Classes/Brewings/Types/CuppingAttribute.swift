//
//  CuppingAttribute.swift
//  Brewer
//
//  Created by Maciej Oczko on 06.08.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation

enum CuppingAttribute: Int32 {
    case Aroma
    case Acidity
    case Aftertaste
    case Balance
    case Body
    case Sweetness
    case Overall
    
    static let allValues = [Aroma, Acidity, Aftertaste, Balance, Body, Sweetness, Overall]
}

extension CuppingAttribute: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .Aroma: return tr(.CuppingAttributeAroma)
        case .Acidity: return tr(.CuppingAttributeAcidity)
        case .Aftertaste: return tr(.CuppingAttributeAftertaste)
        case .Balance: return tr(.CuppingAttributeBalance)
        case .Body: return tr(.CuppingAttributeBody)
        case .Sweetness: return tr(.CuppingAttributeSweetness)
        case .Overall: return tr(.CuppingAttributeOverall)
        }
    }
}
