//
//  LoginM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

//import Foundation

// MARK: - LoginModel
struct LoginM: Codable {
    var token: String?
    var id: Int?
    var genderTitle, name, mobile,image: String?
    var genderID, countryId:Int?
    var homeCountryId,appCountryId : Int?

    //    var code, pharmacistName,createdby: String?
    //    var pharmacistID: Int?
//    var districtID, regionId: Int?
//    var address, pharmacyCode: String?
    
    enum CodingKeys: String, CodingKey {
        case token, id
        case genderTitle , name, mobile,image
        case genderID = "genderId"
        case countryId
        case homeCountryId,appCountryId
        //        case code,pharmacistID = "pharmacistId", pharmacistName,createdby
        //        case districtID = "districtId",regionId
        //        case address, pharmacyCode

    }
    
}


struct MFirebase: Codable {
    let id: Int?
    let code, genderTitle, name, mobile: String?
    let genderID, districtID: Int?
    let address, pharmacyCode: String?

    enum CodingKeys: String, CodingKey {
        case id, code, genderTitle, name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode
    }
}
