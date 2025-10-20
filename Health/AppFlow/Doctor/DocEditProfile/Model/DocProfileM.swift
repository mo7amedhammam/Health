//
//  DocProfileM.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/10/2025.
//


// MARK: - DocProfileM
struct DocProfileM: Codable {
    var id: Int?
    var mobile, name, email: String?
    var countryID, bankID, appCountryID, districtID: Int?
    var regionID, homeCountryID: Int?
    var bio, imagePath, defaultImage: String?
    var specialityID: Int?
    var inactive: Bool?
    var speciality: String?
    var certificateList: [CertificateList]?
    var countryTitle,genderTitle:String?
    var genderId:Int?
    
    enum CodingKeys: String, CodingKey {
        case id, mobile, name, email
        case countryID = "countryId"
        case bankID = "bankId"
        case appCountryID = "appCountryId"
        case districtID = "districtId"
        case regionID = "regionId"
        case homeCountryID = "homeCountryId"
        case bio, imagePath, defaultImage
        case specialityID = "specialityId"
        case inactive, speciality, certificateList
        case countryTitle,genderTitle
        case genderId
    }
}

// MARK: - CertificateList
struct CertificateList: Codable {
    var id: Int?
    var certificatePath: String?
}
