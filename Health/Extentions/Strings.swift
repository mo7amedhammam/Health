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
}
