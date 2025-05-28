//
//  SubcripedPackagesM.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/05/2025.
//



// MARK: - SubcripedPackagesM
struct SubcripedPackagesM: Codable {
    var items: [SubcripedPackageItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct SubcripedPackageItemM: Codable,Hashable {
    var customerPackageID: Int?
    var status, subscriptionDate, lastSessionDate, packageName: String?
    var categoryName, mainCategoryName, doctorName, docotrID: String?
    var sessionCount, attendedSessionCount: Int?
    var packageImage: String?
    var doctorSpeciality,doctorNationality,doctorImage :String?
    var canCancel, canRenew:Bool?
    
    enum CodingKeys: String, CodingKey {
        case customerPackageID = "customerPackageId"
        case status, subscriptionDate, lastSessionDate, packageName, categoryName, mainCategoryName, doctorName
        case docotrID = "docotrId"
        case sessionCount, attendedSessionCount, packageImage
        case doctorSpeciality,doctorNationality,doctorImage
        case canCancel,canRenew
    }
}

