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
}
