//
//  AllergiesMElement.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//


// MARK: - AllergiesMElement
struct AllergiesMElement: Codable {
    var allergyCategoryID: Int?
    var allergyCategoryName: String?
    var allergyList: [AllergyList]?

    enum CodingKeys: String, CodingKey {
        case allergyCategoryID = "allergyCategoryId"
        case allergyCategoryName, allergyList
    }
}

// MARK: - AllergyList
struct AllergyList: Codable {
    var id: Int?
    var name: String?
}

typealias AllergiesM = [AllergiesMElement]
