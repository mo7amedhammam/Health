//
//  SignUpM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

// MARK: - SignUpM -
struct SignUpM: Codable{
    var name, mobile: String?
    var genderID, districtID: Int?
    var address, pharmacyCode: String?
    var id: Int?
    var code, genderTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode, id, code, genderTitle
    }
}


// MARK: - District -
struct DistrictM: Codable {
    var id: Int?
    var title: String?
}

