//
//  ChatsMessageM.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//
import Foundation

// MARK: - ChatsMessageM
struct ChatsMessageM: Codable, Identifiable {
    var id: UUID { UUID() }

    var customerPackageID: Int?
    var comment: String?
    var sendByCustomer, sendByDoctor: Bool?
    var voicePath: String?
    var doctorID: Int?
    var creationDate: String?

    enum CodingKeys: String, CodingKey {
        case customerPackageID = "customerPackageId"
        case comment, sendByCustomer, sendByDoctor, voicePath
        case doctorID = "doctorId"
        case creationDate
    }

    var isFromCustomer: Bool {
        return sendByCustomer == true
    }

    var messageText: String {
        comment ?? ""
    }

    var formattedDate: String {
        guard let creationDate = creationDate,
              let date = ISO8601DateFormatter().date(from: creationDate) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
