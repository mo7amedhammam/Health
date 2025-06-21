//
//  LookupsModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/06/2025.
//

import Foundation

// MARK: - AppCountryM
struct AppCountryM : Codable , Hashable{
    var id: Int?
    var name,flag: String?
}

// MARK: - GendersM
struct GenderM : Codable {
    var id: Int?
    var title : String?
}
