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
}
