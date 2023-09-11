//
//  ModelMyMeasurementsStats.swift
//  Health
//
//  Created by Hamza on 08/09/2023.
//

import Foundation

// MARK: - ModelMyMeasurementsStats
struct ModelMyMeasurementsStats: Codable {
    let medicalMeasurementID: Int?
    let image, title: String?
    let measurementsCount: Int?
    let lastMeasurementValue, lastMeasurementDate, formatValue: String?

    enum CodingKeys: String, CodingKey {
        case medicalMeasurementID = "medicalMeasurementId"
        case image, title, measurementsCount, lastMeasurementValue, lastMeasurementDate, formatValue
    }
}

//.......................................................

struct ModelMeasurementsNormalRange: Codable {
    let id: Int?
    let fromValue, toValue: String?
}

//.......................................................


struct ModelMedicalMeasurements: Codable {
    let measurements: Measurements?
    let measurementsValues: [String]?
}

struct Measurements: Codable {
    let totalCount: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let inNormalRang: Bool?
    let id: Int?
    let date: String?
    let medicalMeasurementTitle: String?
    let medicalMeasurementImage: String?
    let createdBy: Int?
    let createdByName: String?
    let customerID, medicalMeasurementID: Int?
    let value: String?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case inNormalRang, id, date, medicalMeasurementTitle, medicalMeasurementImage, createdBy, createdByName
        case customerID = "customerId"
        case medicalMeasurementID = "medicalMeasurementId"
        case value, comment
    }
}

//............................................

struct ModelCreateMeasurements: Codable {
    let customerID, medicalMeasurementID: Int?
    let value, comment: String?
    let id: Int?
    let date, medicalMeasurementTitle, medicalMeasurementImage: String?
    let createdBy: Int?
    let createdByName: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case medicalMeasurementID = "medicalMeasurementId"
        case value, comment, id, date, medicalMeasurementTitle, medicalMeasurementImage, createdBy, createdByName
    }
}
