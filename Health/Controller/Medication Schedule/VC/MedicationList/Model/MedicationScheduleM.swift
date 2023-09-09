//
//  MedicationScheduleM.swift
//  Health
//
//  Created by wecancity on 09/09/2023.
//

import Foundation

// MARK: - MedicationScheduleM -
struct MedicationScheduleM: Codable {
    var items: [MedicationScheduleItem]?
    var totalCount: Int?
}

// MARK: - MedicationScheduleItem -
struct MedicationScheduleItem: Codable {
    var id: Int?
    var title: String?
    var customerID, drugsCount: Int?
    var startDate, endDate, notes, renewDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case customerID = "customerId"
        case drugsCount, startDate, endDate, notes, renewDate
    }
}
