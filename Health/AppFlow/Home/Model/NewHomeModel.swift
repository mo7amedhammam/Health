//
//  NewHomeModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

// MARK: - UpcomingSessionM
struct UpcomingSessionM: Codable {
    var id: Int?
    var doctorName, sessionDate, timeFrom, packageName: String?
    var categoryName: String?
    var mainCategoryID, categoryID: Int?
    var sessionMethod: String?
    var packageID: Int?

    enum CodingKeys: String, CodingKey {
        case id, doctorName, sessionDate, timeFrom, packageName, categoryName
        case mainCategoryID = "mainCategoryId"
        case categoryID = "categoryId"
        case sessionMethod
        case packageID = "packageId"
    }
}

// MARK: - HomeCategoryM
struct HomeCategoryM: Codable {
    var items: [HomeCategoryItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct HomeCategoryItemM: Codable,Hashable {
    var id: Int?
    var title, homeImage, imagePath: String?
    var subCategoryCount, packageCount: Int?
}
