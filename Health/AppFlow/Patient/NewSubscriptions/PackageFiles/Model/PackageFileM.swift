//
//  PackageFileM.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/05/2025.
//


// MARK: - PackageFileM
// MARK: - PackageFileM
struct PackageFileM: Codable,Hashable {
    var items: [MyFileM]?
    var totalCount: Int?
}

// MARK: - PackageFileM
struct MyFileM: Codable,Hashable {
    var fileName, notes: String?
    var fileTypeID, id: Int?
    var filePath, creationDate: String?
    var customerID: Int?

    enum CodingKeys: String, CodingKey {
        case fileName, notes
        case fileTypeID = "fileTypeId"
        case id, filePath, creationDate
        case customerID = "customerId"
    }
}
extension MyFileM {
    var formattedCreationDate: String? {
        guard let date = self.creationDate else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy/MM/dd")
        return formatedDate // fallback to original string if parsing fails
    }
}
// MARK: - Item
//struct PackageFileItemM: Codable,Hashable {
//    var id, customerPackageID, doctorID: Int?
//    var instText, instDocumentPath, creationDate: String?
//    var fileTypeID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case customerPackageID = "customerPackageId"
//        case doctorID = "doctorId"
//        case instText, instDocumentPath, creationDate
//        case fileTypeID = "fileTypeId"
//    }
//}

//
//
//"fileName": "string",
//     "notes": "string",
//     "fileTypeId": 0,
//     "id": 0,
//     "filePath": "string",
//     "creationDate": "2025-06-29T11:32:03.479Z",
//     "customerId": 0
