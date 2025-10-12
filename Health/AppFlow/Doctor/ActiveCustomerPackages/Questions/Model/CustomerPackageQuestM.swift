//
//  CustomerPackageQuestM.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//


// MARK: - CustomerPackageQuestM
struct CustomerPackageQuestM: Codable {
    var id: Int?
    var question: String?
    var typeID: Int?
    var answer: [Answer]?

    enum CodingKeys: String, CodingKey {
        case id, question
        case typeID = "typeId"
        case answer
    }
}

// MARK: - Answer
struct Answer: Codable {
    var answer, doctorName: String?
    var doctorID: Int?
    var creationDate: String?

    enum CodingKeys: String, CodingKey {
        case answer, doctorName
        case doctorID = "doctorId"
        case creationDate
    }
}
