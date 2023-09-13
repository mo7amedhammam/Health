//
//  ModelNotification.swift
//  Health
//
//  Created by Hamza on 13/09/2023.
//

import Foundation

struct ModelNotification: Codable {
    var items: [ItemNoti]?
    var totalCount: Int?
}

// MARK: - Item
struct ItemNoti: Codable {
    var drugID, doseTimeID, count: Int?
    var startDate: String?
    var days: Int?
    var endDate: String?
    var doseQuantityID: Int?
    var pharmacistComment: String?
    var notification: Bool?
    var id, customerPrescriptionID: Int?
    var doseTimeTitle, doseQuantityTitle: String?
    var doseQuantityValue: Int?
    var drugTitle: String?

    enum CodingKeys: String, CodingKey {
        case drugID = "drugId"
        case doseTimeID = "doseTimeId"
        case count, startDate, days, endDate
        case doseQuantityID = "doseQuantityId"
        case pharmacistComment, notification, id
        case customerPrescriptionID = "customerPrescriptionId"
        case doseTimeTitle, doseQuantityTitle, doseQuantityValue, drugTitle
    }
}
