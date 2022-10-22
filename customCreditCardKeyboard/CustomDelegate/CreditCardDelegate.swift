//
//  CreditCardDelegate.swift
//  customCreditCardKeyboard
//
//  Created by Burak Colak on 22.10.2022.
//

import UIKit

class CreditCardDelegate: NSObject, UITextFieldDelegate {

    private enum MaskCharacters: String {
        case underline = "_"
        case star = "*"
    }

    private enum CreditCardParts: Int {
        case first = 0
        case second = 1
    }

    var textField: UITextField!

    private var textMask: String {
        let startingPart = Array(repeating: MaskCharacters.underline.rawValue, count: 8)
        let starsPart = Array(repeating: MaskCharacters.star.rawValue, count: 4)
        let endingPart = Array(repeating: MaskCharacters.underline.rawValue, count: 4)
        return String(format: "%@%@%@", startingPart.joined(), starsPart.joined(), endingPart.joined())
    }

    func destroy() {
        textField = nil
    }

    func getDefaultMask() -> String {
        textMask
    }

    init(_ field: UITextField) {
        self.textField = field
    }

    var text: String? {
        textField.text
    }

    private var creditCardComponents: [String] {
        let starsPart = Array(repeating: MaskCharacters.star.rawValue, count: 4).joined()
        let text = textField.text ?? ""
        return text.components(separatedBy: starsPart)
    }

    private var firstPart: String {
        let part = creditCardComponents[CreditCardParts.first.rawValue]
        let clean = part.replacingOccurrences(of: MaskCharacters.underline.rawValue, with: "")
        return clean
    }

    private var secondPart: String {
        let part = creditCardComponents[CreditCardParts.second.rawValue]
        let clean = part.replacingOccurrences(of: MaskCharacters.underline.rawValue, with: "")
        return clean
    }

    func getFirstPart() -> String {
        return firstPart
    }

    func getSecondPart() -> String {
        return secondPart
    }

    private var firstIndexOfStar: Int {
        if let index = textMask.firstIndex(of: "*") {
            let distance = textMask.distance(from: textMask.startIndex, to: index)
            return distance
        }else {
            return -1
        }
    }

    private var lastIndexOfStar: Int {
        if let index = textMask.lastIndex(of: "*") {
            let distance = textMask.distance(from: textMask.startIndex, to: index)
            return distance
        }else {
            return -1
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard onlyNumbers(string: string) else { return false }
        guard setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: textMask.count + 1) else { return false }
        guard let text = textField.text else { return false }
        guard let selectedRange = textField.selectedTextRange else { return false }
        let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)

        //MARK: Backspace tapped
        if string.isEmpty {
            if lastIndexOfStar == range.location, let nextRange = getTextRange(index: firstIndexOfStar - 1) {
                let replaced = replaceCharacter(myString: text, firstIndexOfStar - 1, MaskCharacters.underline.rawValue, count: textMask.count)
                textField.text = replaced
                textField.selectedTextRange = nextRange
            }else if let nextRange = getTextRange(index: range.location) {
                let replaced = replaceCharacter(myString: text, range.location, MaskCharacters.underline.rawValue, count: textMask.count)
                textField.text = replaced
                textField.selectedTextRange = nextRange
            }
            return false
        }else {
            let replaced = replaceCharacter(myString: text, range.location, string, count: textMask.count)
            textField.text = replaced

            if firstIndexOfStar - 1 == range.location, let range = getTextRange(index: lastIndexOfStar + 1) {
                textField.selectedTextRange = range
            } else if let range = getTextRange(index: cursorPosition + 1) {
                textField.selectedTextRange = range
            }
            return false
        }
    }
}

extension CreditCardDelegate {
    func replaceCharacter(myString: String, _ index: Int, _ newChar: String, count: Int) -> String {
        guard index < count else { return myString }
        var chars = Array(myString)
        if let character = newChar.first {
            chars[index] = character
        }
        let modifiedString = String(chars)
        return modifiedString
    }

    func setMaxLengthShouldChangeCharactersIn(range: NSRange, string: String, maxLength: Int) -> Bool {
        guard let text = self.text,
              let rangeOfTextToReplace = Range(range, in: text) else {
            return false
        }
        let substringToReplace = text[rangeOfTextToReplace]
        let count = text.count - substringToReplace.count + string.count

        return count <= maxLength
    }

    func getTextRange(index: Int) -> UITextRange? {
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: index),
           let newRange = textField.textRange(from: newPosition, to: newPosition) {
            return newRange
        }
        return nil
    }

    func onlyNumbers(string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
