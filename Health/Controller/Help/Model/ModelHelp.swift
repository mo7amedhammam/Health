//
//  ModelHelp.swift
//  Sehaty
//
//  Created by Hamza on 16/12/2023.
//

import Foundation


// MARK: - ModelGetDrugs
struct ModelHelp: Codable  {
    let title, videoURL: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case videoURL = "videoUrl"
        case id
    }
}
