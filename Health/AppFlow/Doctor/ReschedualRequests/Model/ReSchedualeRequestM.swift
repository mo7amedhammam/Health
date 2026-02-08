//
//  ReSchedualeRequestM.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/02/2026.
//


// MARK: - ReSchedualeRequestM
struct ReSchedualeRequestM: Codable, Hashable {
    var id: Int?
    var oldDate, oldTimeFrom: String?
    var package, category,mainCategory: String?
    var doctor,customer: String?
    var customerPackageID, doctorID, sessionID, shiftID: Int?
    var startDate, timeFrom: String?

    enum CodingKeys: String, CodingKey {
        case id, oldDate, oldTimeFrom, package, category,mainCategory, doctor,customer
        case customerPackageID = "customerPackageId"
        case doctorID = "doctorId"
        case sessionID = "sessionId"
        case shiftID = "shiftId"
        case startDate, timeFrom
    }
}

extension ReSchedualeRequestM{
    var formattedOldDate: String? {
        guard let date =  oldDate else { return nil }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
    }
    
    var formattedNewDate: String? {
        guard let date =  startDate else { return nil }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
    }
    
    var formattedOldTime: String? {
        guard let date =  oldTimeFrom else { return nil }
        return date.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")
    }
    var formattedNewTime: String? {
        guard let date =  timeFrom else { return nil }
        return date.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")
    }
}

