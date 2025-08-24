//
//  AppointmentsM.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/06/2025.
//

import Foundation


// MARK: - AppointmentsM
struct AppointmentsM: Codable {
    var items: [AppointmentsItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct AppointmentsItemM: Codable, Identifiable,Hashable {
    var id,customerPackageId: Int?
    var doctorName, sessionDate, timeFrom, packageName: String?
    var categoryName: String?
    var mainCategoryID: Int?
    var mainCategoryName: String?
    var categoryID: Int?
    var sessionMethod: String?
    var packageID,appCountryPackageId: Int?
    var dayName,customerName: String?

    enum CodingKeys: String, CodingKey {
        case id,customerPackageId, doctorName, sessionDate, timeFrom, packageName, categoryName
        case mainCategoryID = "mainCategoryId"
        case mainCategoryName
        case categoryID = "categoryId"
        case sessionMethod
        case packageID = "packageId",appCountryPackageId
        case dayName,customerName
    }
    
    var formattedDate: String {
        guard let sessionDate = sessionDate else { return "" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: sessionDate) {
            let displayFormatter = DateFormatter()
//            displayFormatter.locale = Locale(identifier: "ar")
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        } else {
            // Try without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            if let date = fallbackFormatter.date(from: sessionDate) {
                let displayFormatter = DateFormatter()
//                displayFormatter.locale = Locale(identifier: "ar")
                displayFormatter.dateStyle = .medium
                return displayFormatter.string(from: date)
            }
        }
        return sessionDate
    }
    
    var formattedTime: String {
        guard let timeFrom = timeFrom else { return "" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: timeFrom) {
            let displayFormatter = DateFormatter()
//            displayFormatter.locale = Locale(identifier: "ar")
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        } else {
            // Try without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            if let date = fallbackFormatter.date(from: timeFrom) {
                let displayFormatter = DateFormatter()
//                displayFormatter.locale = Locale(identifier: "ar")
                displayFormatter.timeStyle = .short
                return displayFormatter.string(from: date)
            }
        }
        return timeFrom
    }
}
