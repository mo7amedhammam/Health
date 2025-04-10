//
//  SignUpM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

// MARK: - SignUpM -
struct SignUpM: Codable{
    var otp, secondsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case otp, secondsCount
    }
}


// MARK: - District -
struct DistrictM: Codable {
    var id: Int?
    var title: String?
}

