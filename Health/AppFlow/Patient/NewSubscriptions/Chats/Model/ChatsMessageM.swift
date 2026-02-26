//
//  ChatsMessageM.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/06/2025.
//
import Foundation

struct ChatsMessageM : Codable{
    var name,image : String?
    var isActive:Bool?
    var MessagesList : [ChatsMessageItemM]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
        case isActive = "isActive"
        case MessagesList = "customerPackageMessageList"
    }
}


// MARK: - ChatsMessageM
struct ChatsMessageItemM: Codable, Identifiable,Equatable {
//    var id: UUID { UUID().uuidString }
    var id = UUID().uuidString // Add this
    
    var customerPackageID: Int?
    var comment: String?
    var sendByCustomer, sendByDoctor: Bool?
    var voicePath: String?
    var doctorID: Int?
    var creationDate: String?
    var customerName,doctorName :String?
    var customerImage,doctorImage :String?

    enum CodingKeys: String, CodingKey {
        case customerPackageID = "customerPackageId"
        case comment, sendByCustomer, sendByDoctor, voicePath
        case doctorID = "doctorId"
        case creationDate
        case customerName,doctorName
        case customerImage,doctorImage
        
//        case messageText = "messageText"
    }

    var isFromMe: Bool {
//        return sendByCustomer == true
        switch Helper.shared.getSelectedUserType(){
        case .Customer,.none:
                return sendByCustomer == true
            case .Doctor:
                return sendByDoctor == true
            }
    }

    var messageText: String {
        comment ?? ""
    }

    var formattedDate: String? {
        guard let date = creationDate else { return nil }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy - hh:mm a")
    }
}
