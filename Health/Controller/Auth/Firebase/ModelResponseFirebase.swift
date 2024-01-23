//
//  ModelResponseFirebase.swift
//  Sehaty
//
//  Created by Hamza on 23/01/2024.
//

import Foundation

struct ModelResponseFirebase: Codable {
    let success: Bool?
    let messageCode: Int?
    let message: String?
    let data: ResponseFirebase?
}

// MARK: - DataClass
struct ResponseFirebase: Codable {
    let pharmacyCode, genderTitle, mobile: String?
    let id: Int?
    let address, name, code: String?
    let districtID, genderID: Int?

    enum CodingKeys: String, CodingKey {
        case pharmacyCode, genderTitle, mobile, id, address, name, code
        case districtID = "districtId"
        case genderID = "genderId"
    }
}
