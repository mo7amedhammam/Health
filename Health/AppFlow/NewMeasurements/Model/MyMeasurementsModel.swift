//
//  ModelMyMeasurementsStats.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/07/2025.
//

import Foundation

// MARK: - ModelMyMeasurementsStats
struct ModelMyMeasurementsStats: Codable {
    
    var medicalMeasurementID: Int?
    var image, title: String?
    var measurementsCount: Int?
    var lastMeasurementValue, lastMeasurementDate, formatValue: String?
    var regExpression, normalRangValue: String?

    enum CodingKeys: String, CodingKey {
        case medicalMeasurementID = "medicalMeasurementId"
        case image, title, measurementsCount, lastMeasurementValue, lastMeasurementDate, formatValue, regExpression, normalRangValue
    }
}
extension ModelMyMeasurementsStats{
    var formatteddate :String? {
        guard let date = lastMeasurementDate else { return nil }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
    }
}

//.......................................................

struct ModelMeasurementsNormalRange: Codable {
    var id: Int?
    var fromValue, toValue: String?
}

//.......................................................


struct ModelMedicalMeasurements: Codable {
    var measurements: Measurements?
    var measurementsValues: [String]?
}

struct Measurements: Codable {
    var totalCount: Int?
    var items: [Item]?
}

// MARK: - Item
struct Item: Codable,Hashable,Identifiable {
    var inNormalRang: Bool?
    var id: Int?
    var date: String?
    var medicalMeasurementTitle: String?
    var medicalMeasurementImage: String?
    var createdBy: Int?
    var createdByName: String?
    var customerID, medicalMeasurementID: Int?
    var value: String?
    var comment: String?

    enum CodingKeys: String, CodingKey {
        case inNormalRang, id, date, medicalMeasurementTitle, medicalMeasurementImage, createdBy, createdByName
        case customerID = "customerId"
        case medicalMeasurementID = "medicalMeasurementId"
        case value, comment
    }
}
extension Item {
    var formatteddate :String? {
        guard let date = self.date else { return nil }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd/MM/yyyy hh:mm a")
    }
}

//............................................

struct ModelCreateMeasurements: Codable {
    var customerID, medicalMeasurementID: Int?
    var value, comment: String?
    var id: Int?
    var date, medicalMeasurementTitle, medicalMeasurementImage: String?
    var createdBy: Int?
    var createdByName: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case medicalMeasurementID = "medicalMeasurementId"
        case value, comment, id, date, medicalMeasurementTitle, medicalMeasurementImage, createdBy, createdByName
    }
}

