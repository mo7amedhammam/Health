//
//  AppointmentsM.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/06/2025.
//

import Foundation


// MARK: - AppointmentsM
struct AppointmentsM: Codable {
    var items: [AppointmentsItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct AppointmentsItemM: Codable, Identifiable,Hashable {
    var id,customerPackageId: Int?
    var doctorName, sessionDate, timeFrom, packageName: String?
    var categoryName: String?
    var mainCategoryID: Int?
    var mainCategoryName: String?
    var categoryID: Int?
    var sessionMethod: String?
    var packageID,appCountryPackageId: Int?
    var dayName,customerName: String?
    var doctorId:Int?
    enum CodingKeys: String, CodingKey {
        case id,customerPackageId, doctorName, sessionDate, timeFrom, packageName, categoryName
        case mainCategoryID = "mainCategoryId"
        case mainCategoryName
        case categoryID = "categoryId"
        case sessionMethod
        case packageID = "packageId",appCountryPackageId
        case dayName,customerName
        case doctorId
    }

    var displayName: String? {
        guard let doctorName = self.doctorName, let customerName = self.customerName else { return "" }

        let name = switch Helper.shared.getSelectedUserType() {
        case .Customer:
            doctorName
        case .Doctor,.none:
            customerName
        }
        return name 
    }
    
    var formattedDate: String? {
        guard let date = self.sessionDate else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy MMM dd")
        return formatedDate // fallback to original string if parsing fails
    }
    
    var formattedTime: String? {
        guard let date = self.timeFrom else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "HH:mm:ss", outputDateFormat: "HH:mm a")
        return formatedDate // fallback to original string if parsing fails
    }
}
