//
//  ModelNotification.swift
//  Health
//
//  Created by Hamza on 13/09/2023.
//

import Foundation

struct ModelNotification: Codable {
    let items: [ItemNoti]?
    let totalCount: Int?
}

// MARK: - Item
struct ItemNoti: Codable {
    let drugID, doseTimeID, count: Int?
    let startDate: String?
    let days: Int?
    let endDate: String?
    let doseQuantityID: Int?
    let pharmacistComment: String?
    let notification: Bool?
    let id, customerPrescriptionID: Int?
    let doseTimeTitle, doseQuantityTitle: String?
    let doseQuantityValue: Int?
    let drugTitle: String?

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
