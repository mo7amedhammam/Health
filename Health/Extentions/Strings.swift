//
//  Strings.swift
//  Health
//
//  Created by wecancity on 07/09/2023.
//

import Foundation

extension String {
    func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)
    }
    
        func isValidEmail() -> Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailValidation = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
                return emailValidation.evaluate(with: self)
            }
        
        func validateSlashs() -> String {
                let newurl  = self.replacingOccurrences(of: "\\",with: "/")
                return  newurl
            }
    func matches(regex pattern: String) -> Bool {
           guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
               // Handle invalid regex pattern here
               return false
           }
           
           let range = NSRange(location: 0, length: utf16.count)
           return regex.firstMatch(in: self, options: [], range: range) != nil
       }
    
    func convertHTMLToPlainText() -> String? {
            guard let data = self.data(using: .utf16, allowLossyConversion: true) else {
                return nil
            }
            
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf16.rawValue
            ]
            
            do {
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                return attributedString.string
            } catch {
                print("Error converting HTML to plain text: \(error)")
                return nil
            }
        }
    func ChangeDateFormat(FormatFrom: String, FormatTo: String, inputLocal: SupportedLocale? = LocalizationManager.shared.currentLanguage == "en" ? .english:.arabic,outputLocal: SupportedLocale? = LocalizationManager.shared.currentLanguage == "en" ? .english:.arabic , inputTimeZone: TimeZone? = TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current, outputTimeZone: TimeZone? = TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current) -> String {
//        let formatter = DateFormatter()
        let formatter = DateFormatter.cachedFormatter

        formatter.locale = inputLocal?.locale ?? .current
        formatter.timeZone = inputTimeZone ?? .current
        formatter.dateFormat = FormatFrom
        
//        print("Original String: \(self)")
//        print("Formatter Locale: \(formatter.locale?.identifier ?? "nil")")
//        print("Formatter TimeZone: \(formatter.timeZone?.identifier ?? "nil")")
        
        // Add this to help parsing ambiguous/invalid DST dates
        formatter.isLenient = true

        guard let date = formatter.date(from: self) else {
            print("Failed to parse date")
            return self
        }
        
        formatter.locale = outputLocal?.locale ?? SupportedLocale.english.locale
        formatter.timeZone = outputTimeZone ?? .current
        formatter.dateFormat = FormatTo
        let newDate = formatter.string(from: date)
//        print("Formatted Date: \(newDate)")
        return newDate
    }
}

extension DateFormatter {
    static let cachedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
}

enum SupportedLocale: String {
    case current
    case english = "en_US"
    case arabic = "ar_EG"
//    case french = "fr_FR"
//    case german = "de_DE"
//    case spanish = "es_ES"
    // Add more cases as needed

    var locale: Locale {
        switch self {
        case .current:
            return Locale.current

         default:
            return Locale(identifier: self.rawValue)

        }
    }
}
