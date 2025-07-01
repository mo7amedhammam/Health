//
//  UpcomingSessionM.swift
//  Sehaty
//
//  Created by mohamed hammam on 02/07/2025.
//


import Foundation

// MARK: - UpcomingSessionM
struct UpcomingSessionM: Codable {
    var id: Int?
    var doctorName, sessionDate, timeFrom, packageName: String?
    var categoryName: String?
    var mainCategoryID, categoryID: Int?
    var sessionMethod: String?
    var packageID: Int?
    var customerName, mainCategoryName, dayName:String?
    var appCountryPackageId:Int?
    
    enum CodingKeys: String, CodingKey {
        case id, doctorName, sessionDate, timeFrom, packageName, categoryName
        case mainCategoryID = "mainCategoryId"
        case categoryID = "categoryId"
        case sessionMethod
        case packageID = "packageId"
        case customerName, mainCategoryName, dayName
        case appCountryPackageId
    }
}

extension UpcomingSessionM{
   var formattedSessionDate: String? {
        guard let date =  sessionDate else { return nil }
       return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
    }
    var formattedSessionTime: String? {
         guard let date =  timeFrom else { return nil }
        return date.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")
     }
    
    var sessionDateTime: Date? {
        guard let dateStr = sessionDate, let timeStr = timeFrom else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let datePart = formatter.date(from: dateStr) else { return nil }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        guard let timePart = timeFormatter.date(from: timeStr) else { return nil }

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: timePart)
        return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                             minute: timeComponents.minute ?? 0,
                             second: timeComponents.second ?? 0,
                             of: datePart)
    }
    func timeDifference() -> (days: Int, hours: Int, minutes: Int) {
           guard let sessionDate = sessionDate,
                 let timeFrom = timeFrom,
                 let date = "\(sessionDate) \(timeFrom)".toDate(format: "yyyy-MM-dd'T'HH:mm:ss HH:mm:ss") else {
               return (0, 0, 0)
           }

           let interval = Int(date.timeIntervalSinceNow)
           if interval <= 0 { return (0, 0, 0) }

           let days = interval / (60 * 60 * 24)
           let hours = (interval % (60 * 60 * 24)) / 3600
           let minutes = (interval % 3600) / 60

           return (days, hours, minutes)
       }

    var isJoinAvailable: Bool {
        guard let session = sessionDateTime else { return false }
        return Date() >= session
    }
}
