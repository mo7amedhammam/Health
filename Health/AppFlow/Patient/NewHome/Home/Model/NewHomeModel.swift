//
//  NewHomeModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//



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
extension MyMeasurementsStatsM{
    var formatteddate :String? {
        guard let date = lastMeasurementDate else { return "" }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
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
    var priceBeforeDiscount, discount, priceAfterDiscount: Double?
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


extension MyMeasurementsStatsM {
    
    static let mockList: [MyMeasurementsStatsM] = [
        MyMeasurementsStatsM(
            medicalMeasurementID: 1,
            image: "blood_pressure",
            title: "Blood Pressure",
            measurementsCount: 12,
            lastMeasurementValue: "120/80",
            lastMeasurementDate: "2025-11-30",
            formatValue: "mmHg",
            regExpression: #"^\d{2,3}/\d{2,3}$"#,
            normalRangValue: "90/60 - 120/80"
        ),
        MyMeasurementsStatsM(
            medicalMeasurementID: 2,
            image: "heart_rate",
            title: "Heart Rate",
            measurementsCount: 20,
            lastMeasurementValue: "72",
            lastMeasurementDate: "2025-11-29",
            formatValue: "bpm",
            regExpression: #"^\d{2,3}$"#,
            normalRangValue: "60 - 100"
        ),
        MyMeasurementsStatsM(
            medicalMeasurementID: 3,
            image: "blood_sugar",
            title: "Blood Sugar",
            measurementsCount: 8,
            lastMeasurementValue: "105",
            lastMeasurementDate: "2025-11-28",
            formatValue: "mg/dL",
            regExpression: #"^\d{2,3}$"#,
            normalRangValue: "70 - 140"
        ),
        MyMeasurementsStatsM(
            medicalMeasurementID: 4,
            image: "weight",
            title: "Weight",
            measurementsCount: 15,
            lastMeasurementValue: "78",
            lastMeasurementDate: "2025-11-27",
            formatValue: "kg",
            regExpression: #"^\d{2,3}$"#,
            normalRangValue: "—"
        ),
        MyMeasurementsStatsM(
            medicalMeasurementID: 5,
            image: "temperature",
            title: "Body Temperature",
            measurementsCount: 6,
            lastMeasurementValue: "36.8",
            lastMeasurementDate: "2025-11-26",
            formatValue: "°C",
            regExpression: #"^\d{2}(\.\d)?$"#,
            normalRangValue: "36.1 - 37.2"
        )
    ]
}

