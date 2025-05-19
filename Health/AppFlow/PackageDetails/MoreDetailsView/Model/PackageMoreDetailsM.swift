//
//  PackageMoreDetailsM.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/05/2025.
//


// MARK: - MoreDetailsPackageM
struct PackageMoreDetailsM: Codable {
    var id: Int?
    var doctorData: DoctorData?
    var packageData: PackageData?
}

// MARK: - DoctorData
struct DoctorData: Codable {
    var doctorID: Int?
    var doctorName,doctorImage, speciality: String?

    enum CodingKeys: String, CodingKey {
        case doctorID = "doctorId"
        case doctorName, doctorImage, speciality
    }
}

// MARK: - PackageData
struct PackageData: Codable {
    var packageID: Int?
    var packageName, mainCategoryName, categoryName: String?
    var sessionCount, duration, priceBeforeDiscount, discount: Int?
    var priceAfterDiscount: Int?

    enum CodingKeys: String, CodingKey {
        case packageID = "packageId"
        case packageName, mainCategoryName, categoryName, sessionCount, duration, priceBeforeDiscount, discount, priceAfterDiscount
    }
}

//----
// MARK: -- AvailableDayM --
struct AvailableDayM: Codable,Hashable {
    var dayId: Int?
    var date,dayName: String?
 
    enum CodingKeys: String, CodingKey {
        case dayId = "dayId"
        case date,dayName
    }
}
