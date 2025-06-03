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


// MARK: - MyMeasurementsStatsM
struct MyMeasurementsStatsM: Codable,Hashable {
    var medicalMeasurementID: Int?
    var image, title: String?
    var measurementsCount: Int?
    var lastMeasurementValue, lastMeasurementDate, formatValue, regExpression: String?
    var normalRangValue: String?

    enum CodingKeys: String, CodingKey {
        case medicalMeasurementID = "medicalMeasurementId"
        case image, title, measurementsCount, lastMeasurementValue, lastMeasurementDate, formatValue, regExpression, normalRangValue
    }
}

// MARK: - FeaturedPackages
struct FeaturedPackagesM: Codable {
    var items: [FeaturedPackageItemM]?
    var totalCount: Int?
}

// MARK: - FeaturedPackageItemM
struct FeaturedPackageItemM: Codable,Hashable {
    var id: Int?
    var name: String?
    var mainCategoryID, subCategoryID: Int?
    var categoryName,mainCategoryName: String?
    var sessionCount: Int?
    var isWishlist: Bool?
    var priceBeforeDiscount, discount, priceAfterDiscount: Int?
    var homeImage, imagePath: String?
    var doctorCount: Int?
    var appCountryPackageId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case mainCategoryID = "mainCategoryId"
        case subCategoryID = "subCategoryId"
        case categoryName,mainCategoryName, sessionCount, isWishlist, priceBeforeDiscount, discount, priceAfterDiscount, homeImage, imagePath, doctorCount
        case appCountryPackageId
    }
}

    
// MARK: - MostBookedPackagesM -
//struct MostBookedPackagesM: Codable ,Hashable{
//    var id: Int?
//    var name: String?
//    var mainCategoryID, subCategoryID: Int?
//    var categoryName: String?
//    var sessionCount: Int?
//    var isWishlist: Bool?
//    var priceBeforeDiscount, discount, priceAfterDiscount: Int?
//    var homeImage, imagePath: String?
//    var doctorCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case mainCategoryID = "mainCategoryId"
//        case subCategoryID = "subCategoryId"
//        case categoryName, sessionCount, isWishlist, priceBeforeDiscount, discount, priceAfterDiscount, homeImage, imagePath, doctorCount
//    }
//}

