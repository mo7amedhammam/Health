//
//  PackageFileM.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/05/2025.
//


// MARK: - PackageFileM
// MARK: - PackageFileM
struct PackageFileM: Codable,Hashable {
    var items: [PackageFileItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct PackageFileItemM: Codable,Hashable {
    var id, customerPackageID, doctorID: Int?
    var instText, instDocumentPath, creationDate: String?
    var fileTypeID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case customerPackageID = "customerPackageId"
        case doctorID = "doctorId"
        case instText, instDocumentPath, creationDate
        case fileTypeID = "fileTypeId"
    }
}

//
//
//"fileName": "string",
//     "notes": "string",
//     "fileTypeId": 0,
//     "id": 0,
//     "filePath": "string",
//     "creationDate": "2025-06-29T11:32:03.479Z",
//     "customerId": 0
