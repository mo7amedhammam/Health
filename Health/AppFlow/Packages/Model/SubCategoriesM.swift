//
//  SubCategoriesM.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/05/2025.
//


// MARK: - SubCategoriesM
struct SubCategoriesM: Codable {
    var items: [SubCategoryItemM]?
    var totalCount: Int?
}

// MARK: - Item
struct SubCategoryItemM: Codable,Hashable {
    var id: Int?
    var name: String?
    var packageCount: Int?
    var image: String?
}
