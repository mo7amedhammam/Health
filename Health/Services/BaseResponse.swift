//
//  BaseResponse.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import Foundation
    
struct BaseResponse<T:Codable> : Codable {
//        let id : String?
        let message: String?
        let messageCode: Int?
        let data: T?
        let success: Bool?

        enum CodingKeys: String, CodingKey {
//            case id = "id"
            case message = "message"
            case messageCode = "messageCode"
            case data = "data"
            case success = "success"
        }
    
//    init() {
////        self.id = ""
//        self.message = ""
//        self.messageCode = 0
//        self.success = false
//        self.data = T.self as? T
//    }
}

struct ServerErrorResponse: Decodable {
    let message: String
}

public enum EventHandler:Equatable {
    case none
    case loading
    case stopLoading
    case success
    case error(Int?=0,String?)
}

// input multipart
struct MultipartFormDataPart {
    let name: String
    let filename: String?
    let mimeType: String?
    let data: Data?

    // Text fields
    init(name: String, value: String) {
        self.name = name
        self.filename = nil
        self.mimeType = nil
        self.data = value.data(using: .utf8)
    }

    // Files
    init(name: String, filename: String, mimeType: String, data: Data) {
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
    }
}
