//
//  TicketM.swift
//  Sehaty
//
//  Created by mohamed hammam on 22/05/2025.
//

import Foundation

// MARK: - TicketM
struct TicketM: Codable,Equatable {
    static func == (lhs: TicketM, rhs: TicketM) -> Bool {
      return lhs.doctorData == rhs.doctorData && lhs.packageData == rhs.packageData && lhs.bookedTimming == rhs.bookedTimming
    }
    
    var doctorData: DoctorData?
    var packageData: PackageData?
    var bookedTimming: BookedTimming?
    var coupon: Coupon?
}

// MARK: - BookedTimming
struct BookedTimming: Codable,Equatable {
    var booked: Bool?
    var timefrom, timeTo, dayName, date: String?
}

// MARK: - Coupon
struct Coupon: Codable {
    var totalBeforeDiscount, discount, totalAfterDiscount: Int?
}

