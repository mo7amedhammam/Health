//
//  MedicationScheduleDetailsM.swift
//  Health
//
//  Created by wecancity on 09/09/2023.
//


// MARK: - MedicationScheduleDrugM
struct MedicationScheduleDrugM: Codable {
    var id, drugID, doseTimeID, count: Int?
    var startDate: String?
    var days: Int?
    var endDate: String?
    var doseQuantityID: Int?
    var pharmacistComment: String?
    var notification: Bool?
    var customerPrescriptionID: Int?
    var doseTimeTitle, doseQuantityTitle: String?
    var doseQuantityValue: Int?
    var drugTitle: String?
    var timeIsOver, active: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case drugID = "drugId"
        case doseTimeID = "doseTimeId"
        case count, startDate, days, endDate
        case doseQuantityID = "doseQuantityId"
        case pharmacistComment, notification
        case customerPrescriptionID = "customerPrescriptionId"
        case doseTimeTitle, doseQuantityTitle, doseQuantityValue, drugTitle, timeIsOver, active
    }
}
