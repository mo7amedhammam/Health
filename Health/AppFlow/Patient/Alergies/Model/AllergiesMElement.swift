//
//  AllergiesMElement.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//


// MARK: - AllergiesMElement
struct AllergiesMElement: Codable,Hashable {
    var allergyCategoryID: Int?
    var allergyCategoryName: String?
    var allergyList: [AllergyList]?

    enum CodingKeys: String, CodingKey {
        case allergyCategoryID = "allergyCategoryId"
        case allergyCategoryName, allergyList
    }
}

// MARK: - AllergyList
struct AllergyList: Codable,Hashable {
    var id: Int?
    var name: String?
    var hasAllergy: Bool?
}

typealias AllergiesM = [AllergiesMElement]
