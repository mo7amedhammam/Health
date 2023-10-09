//
//  AlmostFinishedPrescriptionM.swift
//  Sehaty
//
//  Created by wecancity on 09/10/2023.
//

// MARK: - AlmostFinishedPrescriptionM
struct AlmostFinishedPrescriptionM: Codable {
    var items: [PrescriptionM]?
    var totalCount: Int?
}

// MARK: - Item
struct PrescriptionM: Codable {
    var id: Int?
    var drugTitle, endDate: String?
}
