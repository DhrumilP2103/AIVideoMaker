//
//  ExString.swift
//  ETWorld
//
//  Created by Kiran Jamod on 07/11/24.
//

import Foundation
import UIKit

extension String {
    func isValidWebsite() -> Bool {
        // Basic regex for URL validation
        let pattern = #"^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(/.*)?$"#
        
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.utf16.count)
        
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func validatePassword() -> (Bool,String) {
        let errorMessage = "Invalid password format. The password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one symbol."
        let minLength = 8
        let uppercaseRegex = ".*[A-Z]+.*"
        let lowercaseRegex = ".*[a-z]+.*"
        let digitRegex = ".*[0-9]+.*"
        let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"

        if self.count < minLength {
            return (false, errorMessage)
        }
        
        let uppercaseTest = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        if !uppercaseTest.evaluate(with: self) {
            return (false, errorMessage)
        }
        
        let lowercaseTest = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        if !lowercaseTest.evaluate(with: self) {
            return (false, errorMessage)
        }
        
        let digitTest = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        if !digitTest.evaluate(with: self) {
            return (false, errorMessage)
        }
        
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        if !specialCharacterTest.evaluate(with: self) {
            return (false, errorMessage)
        }

        return (true, "Password is strong!")
    }
}

func formattedDate(from input: String,
                   inputFormatterStr: String = "yyyy-MM-dd ",
                   outputFormatterStr: String = "dd MMM yyyy") -> String {
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = inputFormatterStr
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")  // stable parsing
    
    let outputFormatter = DateFormatter()
    outputFormatter.locale = Locale(identifier: "en_US")
    outputFormatter.calendar = Calendar(identifier: .gregorian)
    outputFormatter.dateFormat = outputFormatterStr
    
    guard let date = inputFormatter.date(from: input) else {
        return input
    }
    
    return outputFormatter.string(from: date)
}

func validatePercentageInput(_ input: String) -> String {
    var filtered = input.filter { "0123456789.".contains($0) }

    // ❌ Don't allow first dot
    if filtered.first == "." {
        filtered.removeFirst()
    }

    // ❌ Prevent multiple dots
    if filtered.components(separatedBy: ".").count > 2 {
        filtered.removeLast()
    }

    // ❌ Limit to 2 digits after decimal
    if let dotIndex = filtered.firstIndex(of: ".") {
        let decimalPart = filtered[filtered.index(after: dotIndex)...]
        if decimalPart.count > 2 {
            filtered = String(filtered.prefix(upTo: filtered.index(dotIndex, offsetBy: 3)))
        }
    }

    // ❌ Max 100
    if let value = Double(filtered), value > 100 {
        return "100"
    }

    return filtered
}


func validatePriceInput(_ input: String) -> String {
    // Allow only numbers and dot
    var filtered = input.filter { "0123456789.".contains($0) }

    // ❌ Don't allow first dot
    if filtered.first == "." {
        filtered.removeFirst()
    }

    // ❌ Prevent multiple dots
    if filtered.components(separatedBy: ".").count > 2 {
        filtered.removeLast()
    }

    // ❌ Limit to 2 digits after decimal
    if let dotIndex = filtered.firstIndex(of: ".") {
        let decimalPart = filtered[filtered.index(after: dotIndex)...]
        if decimalPart.count > 2 {
            filtered = String(filtered.prefix(upTo: filtered.index(dotIndex, offsetBy: 3)))
        }
    }

    return filtered
}


extension String {
    /// Converts a string in "yyyy-MM-dd" format to a Date.
    func toDate() -> Date? {
        return Utilities().apiDateFormater.date(from: self)
    }
}
