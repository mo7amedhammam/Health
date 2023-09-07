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
