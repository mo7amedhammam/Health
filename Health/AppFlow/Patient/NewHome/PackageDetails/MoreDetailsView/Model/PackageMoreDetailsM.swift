//
//  PackageMoreDetailsM.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/05/2025.
//


// MARK: - MoreDetailsPackageM
struct PackageMoreDetailsM: Codable {
    var id: Int?
    var appCountryPackageId:Int?
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
let mockAvailableDays: [AvailableDayM] = [
    AvailableDayM(dayId: 6, date: "2025-11-01T00:00:00", dayName: "Saturday"),
    AvailableDayM(dayId: 6, date: "2025-11-08T00:00:00", dayName: "Saturday"),
    AvailableDayM(dayId: 6, date: "2025-11-15T00:00:00", dayName: "Saturday"),
    AvailableDayM(dayId: 6, date: "2025-11-22T00:00:00", dayName: "Saturday"),
    AvailableDayM(dayId: 6, date: "2025-11-29T00:00:00", dayName: "Saturday"),

    AvailableDayM(dayId: 1, date: "2025-11-10T00:00:00", dayName: "Monday"),
    AvailableDayM(dayId: 1, date: "2025-11-17T00:00:00", dayName: "Monday"),
    AvailableDayM(dayId: 1, date: "2025-11-24T00:00:00", dayName: "Monday"),

    AvailableDayM(dayId: 3, date: "2025-11-12T00:00:00", dayName: "Wednesday"),
    AvailableDayM(dayId: 3, date: "2025-11-19T00:00:00", dayName: "Wednesday"),
    AvailableDayM(dayId: 3, date: "2025-11-26T00:00:00", dayName: "Wednesday")
]
// MARK: -- AvailableTimeShiftM --
struct AvailableTimeShiftM: Codable,Hashable {
    var id: Int?
    var name,timeFrom,timeTo: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case name,timeFrom,timeTo
    }
}
let mockAvailableTimeShifts: [AvailableTimeShiftM] = [
    AvailableTimeShiftM(id: 1, name: "Morning",   timeFrom: "08:00:00", timeTo: "12:00:00"),
    AvailableTimeShiftM(id: 2, name: "Afternoon", timeFrom: "12:00:00", timeTo: "16:00:00"),
    AvailableTimeShiftM(id: 3, name: "Evening",   timeFrom: "16:00:00", timeTo: "20:00:00")
]

// MARK: -- AvailableTimeShiftM --
struct AvailableSchedualsM: Codable,Hashable {
    var booked: Bool?
    var timefrom,timeTo: String?

    enum CodingKeys: String, CodingKey {
        case booked
        case timefrom,timeTo
    }
}
let mockAvailableSchedules: [AvailableSchedualsM] = [
    AvailableSchedualsM(booked: false, timefrom: "08:00:00", timeTo: "08:30:00"),
    AvailableSchedualsM(booked: true,  timefrom: "08:30:00", timeTo: "09:00:00"),
    AvailableSchedualsM(booked: false, timefrom: "09:00:00", timeTo: "09:30:00"),
    AvailableSchedualsM(booked: false, timefrom: "09:30:00", timeTo: "10:00:00"),
    AvailableSchedualsM(booked: true,  timefrom: "10:00:00", timeTo: "10:30:00"),
    AvailableSchedualsM(booked: false, timefrom: "10:30:00", timeTo: "11:00:00"),
    AvailableSchedualsM(booked: false, timefrom: "11:00:00", timeTo: "11:30:00"),
    AvailableSchedualsM(booked: true,  timefrom: "11:30:00", timeTo: "12:00:00")
]


