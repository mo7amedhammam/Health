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


//.......................................
// create notification

struct ModelCreateNotification: Codable {
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

//.............................................
struct ModelGetDrugs: Codable {
    let id: Int?
    let image, drugGroupTitle: String?
    let isVerified: Bool?
    let title: String?
    let order: Int?
    let patientCounseling: String?
    let drugGroupID: Int?

    enum CodingKeys: String, CodingKey {
        case id, image, drugGroupTitle, isVerified, title, order, patientCounseling
        case drugGroupID = "drugGroupId"
    }
}

//.............................................
