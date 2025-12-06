//
//  CustomDateFormat.swift
//  Sehaty
//
//  Created by mohamed hammam on 21/05/2025.
//

import Foundation

struct CustomDateFormat: FormatStyle, Sendable {
    let format: String
    let locale: Locale
    let timeZone: TimeZone
    
    func format(_ value: Date) -> String {
        let formatter = DateFormatter.cachedFormatter
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter.string(from: value)
    }
}

extension FormatStyle where Self == CustomDateFormat {
    static func customDateFormat(
        _ format: String,
        locale: SupportedLocale? = LocalizationManager.shared.currentLanguage.lowercased() == "en" ? .english:.arabic,
        timeZone: TimeZone? = TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current
    ) -> CustomDateFormat {
        CustomDateFormat(format: format, locale: locale?.locale ?? .current, timeZone: timeZone ?? TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current)
    }
}
