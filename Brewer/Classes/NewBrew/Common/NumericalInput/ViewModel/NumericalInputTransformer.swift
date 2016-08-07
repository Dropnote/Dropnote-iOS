//
// Created by Maciej Oczko on 20.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

protocol NumericalInputTransformerType {
    func initialString() -> String
    func transform(withRange range: NSRange, replacementString string: String) -> String
}

extension InputTransformer {
    
    static func temperatureTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 5, separatorIndex: 5, separator: ".")
    }

    static func numberTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 5, separatorIndex: 4, separator: ".")
    }

    static func timeTransformer() -> NumericalInputTransformerType {
        return InputTransformer(maximumDigitsCount: 4, separatorIndex: 2, separator: ":")
    }
}

final class InputTransformer: NumericalInputTransformerType {
    private var digits = [Int]()
    private let maximumDigitsCount: Int
    private let separatorIndex: Int
    private let separator: Character

    init(maximumDigitsCount count: Int, separatorIndex index: Int, separator character: Character) {
        maximumDigitsCount = count
        separatorIndex = index
        separator = character
    }

    func initialString() -> String {
        var string = ""
        for _ in 0..<maximumDigitsCount {
            string += "0"
        }
        return formatResult(string)
    }

    func transform(withRange range: NSRange, replacementString string: String) -> String {
        if shouldAppendDigit(range) {
            if let intValue = Int(string) {
                digits.append(intValue)
            } else {
                digits.append(0)
            }
        }

        if shouldRemoveDigit(range) && !digits.isEmpty {
            digits.removeLast()
        }

        let result = digitsCopyWithFilledZeros()
            .map(String.init)
            .joinWithSeparator("")

        return formatResult(result)
    }

    // MARK: Helpers

    private func shouldAppendDigit(range: NSRange) -> Bool {
        return digits.count <= maximumDigitsCount && range.length == 0
    }

    private func shouldRemoveDigit(range: NSRange) -> Bool {
        return range.length != 0
    }

    private func digitsCopyWithFilledZeros() -> [Int] {
        var stringable = digits
        while stringable.count < maximumDigitsCount {
            stringable.insert(0, atIndex: 0)
        }
        return stringable
    }
    
    private func formatResult(result: String) -> String {
        let numberRepresentation = Double(insertSeparator(".", toString: result))!
        return numberRepresentation
            .format(".\(maximumDigitsCount - separatorIndex)")
            .stringByReplacingOccurrencesOfString(".", withString: String(separator))
    }

    private func insertSeparator(separator: Character, toString string: String) -> String {
        let index = string.startIndex.advancedBy(separatorIndex)
        var mutableString = String(string)
        mutableString.insert(separator, atIndex: index)
        return mutableString
    }
}
