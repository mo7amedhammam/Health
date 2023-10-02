//
//  ModelMyMeasurementsStats.swift
//  Health
//
//  Created by Hamza on 08/09/2023.
//

import Foundation

// MARK: - ModelMyMeasurementsStats
struct ModelMyMeasurementsStats: Codable {
    var medicalMeasurementID: Int?
    var image, title: String?
    var measurementsCount: Int?
    var lastMeasurementValue, lastMeasurementDate, formatValue: String?

    enum CodingKeys: String, CodingKey {
        case medicalMeasurementID = "medicalMeasurementId"
        case image, title, measurementsCount, lastMeasurementValue, lastMeasurementDate, formatValue
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
struct Item: Codable,Equatable {
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

