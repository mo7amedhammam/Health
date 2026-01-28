//
//  TimeSlot.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/08/2025.
//

import Foundation

struct SchedualeM: Codable, Hashable {
    var id: Int?
    var fromStartDate, toEndDate: String?
}

extension SchedualeM {
    var formattedstartdate: String? {
        guard let date = fromStartDate else { return "" }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy")
    }
    
    var formattedenddate: String? {
        guard let date = toEndDate else { return "" }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy")
    }
    
    static var mockList: [SchedualeM] {
        [
            SchedualeM(id: 1, fromStartDate: "2025-11-01T08:00:00", toEndDate: "2025-11-01T10:00:00"),
            SchedualeM(id: 2, fromStartDate: "2025-11-01T12:00:00", toEndDate: "2025-11-01T14:00:00"),
            SchedualeM(id: 3, fromStartDate: "2025-11-02T09:30:00", toEndDate: "2025-11-02T11:00:00"),
            SchedualeM(id: 4, fromStartDate: "2025-11-03T15:00:00", toEndDate: "2025-11-03T17:30:00"),
            SchedualeM(id: 5, fromStartDate: "2025-11-05T08:00:00", toEndDate: "2025-11-05T09:00:00")
        ]
    }
}

// MARK: - SchedualeDetailsM
struct SchedualeDetailsM: Codable {
    var id, doctorScheduleID: Int?
    var dayList: [DayList]?
    var fromStartDate, toEndDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case doctorScheduleID = "doctorScheduleId"
        case dayList, fromStartDate, toEndDate
    }
}

// MARK: - DayList
struct DayList: Codable {
    var id: Int?           // This is null in the API response
    var dayId: Int?        // This is the actual day identifier (0-6)
    var name: String?
    var isSelected: Bool?
    var shiftList: [ShiftList]?
}

// MARK: - ShiftList
struct ShiftList: Codable {
    var id: Int?           // This is null in the API response
    var shiftId: Int?      // This is the actual shift identifier
    var name: String?
    var fromTime, toTime: String?
    var isSelected: Bool?
}
