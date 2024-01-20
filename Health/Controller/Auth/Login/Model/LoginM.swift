//
//  LoginM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

//import Foundation

// MARK: - LoginModel
struct LoginM: Codable{
    var name, mobile: String?
    var genderID, districtID: Int?
    var address, pharmacyCode: String?
    var id: Int?
    var code, genderTitle, token: String?
    
    enum CodingKeys: String, CodingKey {
        case name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode, id, code, genderTitle, token
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
