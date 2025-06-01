//
//  PackageFileM.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/05/2025.
//


// MARK: - PackageFileM
struct PackageFileM: Codable,Hashable {
    var customerPackageID, doctorID: Int?
    var instText: String?
    var fileTypeID, id: Int?
    var instDocumentPath: String?

    enum CodingKeys: String, CodingKey {
        case customerPackageID = "customerPackageId"
        case doctorID = "doctorId"
        case instText
        case fileTypeID = "fileTypeId"
        case id, instDocumentPath
    }
}
