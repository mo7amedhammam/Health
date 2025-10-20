//
//  getprofile.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/10/2025.
//

// MARK: - CustProfileM
struct CustProfileM: Codable {
    var name, mobile: String?
    var genderID, countryID, id: Int?
    var code, image, genderTitle, createdby: String?
    var verifiedOtp: String?
    var districtID, appCountryID, regionID, homeCountryID: Int?
    var countryTitle:String?
    enum CodingKeys: String, CodingKey {
        case name, mobile
        case genderID = "genderId"
        case countryID = "countryId"
        case id, code, image, genderTitle, createdby, verifiedOtp
        case districtID = "districtId"
        case appCountryID = "appCountryId"
        case regionID = "regionId"
        case homeCountryID = "homeCountryId"
        case countryTitle
    }
}


// MARK: - GetProfile
//struct GetProfileM: Codable {
//    var token: String?
//    var id: Int?
//    var genderTitle, name, mobile,image: String?
//    var genderID, countryId:Int?
//    var homeCountryId,appCountryId : Int?
//
//    //    var code, pharmacistName,createdby: String?
//    //    var pharmacistID: Int?
////    var districtID, regionId: Int?
////    var address, pharmacyCode: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case token, id
//        case genderTitle , name, mobile,image
//        case genderID = "genderId"
//        case countryId
//        case homeCountryId,appCountryId
//        //        case code,pharmacistID = "pharmacistId", pharmacistName,createdby
//        //        case districtID = "districtId",regionId
//        //        case address, pharmacyCode
//
//    }
//    
//}

