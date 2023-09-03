//
//  LoginModel.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

//import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    var id: Int?
    var token, name, mobile, email: String?
    var imagePath, role: String?
    var roleID,profileStatusId: Int?
    var customerHasInterests :Bool?
    enum CodingKeys: String, CodingKey {
        case id, token, name, mobile, email, imagePath, role
        case roleID = "roleId"
        case profileStatusId = "profileStatusId"
        case customerHasInterests = "customerHasInterests"

    }
}
