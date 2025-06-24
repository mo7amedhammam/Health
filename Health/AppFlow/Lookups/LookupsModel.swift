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
struct GenderM : Codable,Hashable {
    var id: Int?
    var title : String?
}

// MARK: - LanguageM
struct LanguageM : Codable,Hashable,Equatable {
    var id: Int?
    var lang1 , flag: String?
    
//    var languageCode:String?{
//        switch id {
//        case 1:
//            return "ar"
//        default:
//            return "en"
//        }
//    }
}

// MARK: -- FileTypeM --
struct FileTypeM : Codable,Hashable {
    var id: Int?
    var type : String?
}
