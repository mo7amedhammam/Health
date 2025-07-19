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
struct DoctorData: Codable,Equatable {
    
    var doctorID: Int?
    var doctorName,doctorImage, speciality: String?
    var packageDoctorId:Int?
    var nationality,flag:String?
    enum CodingKeys: String, CodingKey {
        case doctorID = "doctorId"
        case doctorName, doctorImage, speciality
        case packageDoctorId,nationality,flag
    }
}

// MARK: - PackageData
struct PackageData: Codable,Equatable {
    var packageID: Int?
    var packageName, mainCategoryName, categoryName: String?
    var sessionCount, duration: Int?
    var priceBeforeDiscount,priceAfterDiscount, discount: Double?
    var appCountryPackageId: Int?
    enum CodingKeys: String, CodingKey {
        case packageID = "packageId"
        case packageName, mainCategoryName, categoryName, sessionCount, duration, priceBeforeDiscount, discount, priceAfterDiscount
        case appCountryPackageId
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

// MARK: -- AvailableTimeShiftM --
struct AvailableTimeShiftM: Codable,Hashable {
    var id: Int?
    var name,timeFrom,timeTo: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case name,timeFrom,timeTo
    }
}


// MARK: -- AvailableTimeShiftM --
struct AvailableSchedualsM: Codable,Hashable {
    var booked: Bool?
    var timefrom,timeTo: String?

    enum CodingKeys: String, CodingKey {
        case booked
        case timefrom,timeTo
    }
}


