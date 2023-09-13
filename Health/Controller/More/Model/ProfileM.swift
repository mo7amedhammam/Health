//
//  ProfileM.swift
//  Health
//
//  Created by wecancity on 13/09/2023.
//

// MARK: - ProfileM -
struct ProfileM: Codable {
    var id: Int?
    var name: String? 
    var mobile: String?
    var code, genderTitle: String?
    var genderID, districtID: Int?
    var address: String?
    var pharmacyCode: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, code, genderTitle, name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
