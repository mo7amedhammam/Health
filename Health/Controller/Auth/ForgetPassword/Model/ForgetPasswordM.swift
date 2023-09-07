//
//  ForgetPasswordM.swift
//  Health
//
//  Created by wecancity on 07/09/2023.
//

// MARK: - ForgetPasswordM -
struct ForgetPasswordM: Codable {
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
