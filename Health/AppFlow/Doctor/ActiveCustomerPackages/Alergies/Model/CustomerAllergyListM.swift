//
//  CustomerAllergyListM.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//



// MARK: - CustomerAllergyListM
struct CustomerAllergyListM: Codable {
    var allergyCategoryID: Int?
    var allergyCategoryName: String?
    var allergyList: [CustomerAllergyItem]?

    enum CodingKeys: String, CodingKey {
        case allergyCategoryID = "allergyCategoryId"
        case allergyCategoryName, allergyList
    }
}

// MARK: - CustomerAllergyItem
struct CustomerAllergyItem: Codable {
    var id: Int?
    var name: String?
    var hasAllergy: Bool?
}

let mockAllergies: [CustomerAllergyListM] = [
    CustomerAllergyListM(
        allergyCategoryID: 1,
        allergyCategoryName: "حساسية الطعام",
        allergyList: [
            .init(id: 1, name: "منتجات الألبان", hasAllergy: true),
            .init(id: 2, name: "المحار والأسماك", hasAllergy: true),
            .init(id: 3, name: "الصويا", hasAllergy: false)
        ]
    ),
    CustomerAllergyListM(
        allergyCategoryID: 2,
        allergyCategoryName: "حساسية الأدوية",
        allergyList: [
            .init(id: 4, name: "البنسلين", hasAllergy: true)
        ]
    ),
    CustomerAllergyListM(
        allergyCategoryID: 3,
        allergyCategoryName: "حساسية بيئية",
        allergyList: [
            .init(id: 5, name: "العفن والرطوبة", hasAllergy: true),
            .init(id: 6, name: "وبر الحيوانات", hasAllergy: true)
        ]
    ),
    CustomerAllergyListM(
        allergyCategoryID: 4,
        allergyCategoryName: "حساسية الجلد",
        allergyList: [
            .init(id: 7, name: "اللاتكس", hasAllergy: true)
        ]
    ),
    CustomerAllergyListM(
        allergyCategoryID: 5,
        allergyCategoryName: "حساسية الجهاز التنفسي",
        allergyList: [
            .init(id: 8, name: "الربو", hasAllergy: true)
        ]
    )
]
