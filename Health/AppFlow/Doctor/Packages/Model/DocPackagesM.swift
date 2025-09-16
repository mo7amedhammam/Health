//
//  DocPackagesM.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/09/2025.
//


// MARK: - DocPackages
struct DocPackagesM: Codable {
    var items: [DocPackageItemM]?
    var totalCount: Int?
}

// MARK: - DocPackageItemM
struct DocPackageItemM: Codable,Hashable {
    var doctorID, appCountryPackageID, id, sessionCount: Int?
    var packageName, categoryName, mainCategoryName: String?
    var participantCount: Int?
    var price, discount, priceAfterDiscount: Double?
    var packageIamge, currency: String?

    enum CodingKeys: String, CodingKey {
        case doctorID = "doctorId"
        case appCountryPackageID = "appCountryPackageId"
        case id, sessionCount, packageName, categoryName, mainCategoryName, price, discount, priceAfterDiscount, participantCount, packageIamge, currency
    }
}


struct CategoriyListItemM: Codable,Hashable {
    var id : Int?
    var title:String?
    var status:Bool?
}
