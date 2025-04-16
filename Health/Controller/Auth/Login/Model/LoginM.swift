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
    var code, pharmacistName: String?
    var pharmacistID: Int?
    var genderTitle, createdby, name, mobile: String?
    var genderID, districtID: Int?
    var address, pharmacyCode: String?

    enum CodingKeys: String, CodingKey {
        case token, id, code, pharmacistName
        case pharmacistID = "pharmacistId"
        case genderTitle, createdby, name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode
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
