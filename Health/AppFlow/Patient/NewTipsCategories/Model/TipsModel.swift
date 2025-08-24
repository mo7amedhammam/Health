//
//  TipsAllM.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/07/2025.
//

// MARK: - TipsAllM -
struct TipsAllM: Codable {
    var items: [TipsAllItem]?
    var totalCount: Int?
}

// MARK: - Item
struct TipsAllItem: Codable,Equatable {
    var title: String?
    var order, id: Int?
    var image: String?
    var subjectsCount: Int?
}


// MARK: - TipsNewest -
struct TipsNewestM: Codable,Hashable {
    var title, description, date: String?
    var tipCategoryID: Int?
    var drugGroupIDS: [Int]?
    var id: Int?
    var image, tipCategoryTitle: String?
    var views: Int?

    enum CodingKeys: String, CodingKey {
        case title, description, date
        case tipCategoryID = "tipCategoryId"
        case drugGroupIDS = "drugGroupIds"
        case id, image, tipCategoryTitle, views
    }
}


// MARK: - TipsByCategoryM -
struct TipsByCategoryM: Codable {
    var items: [TipDetailsM]?
    var totalCount: Int?
}


// MARK: - TipDetailM -
struct TipDetailsM: Codable {
    var id: Int?
    var title, description, date: String?
    var tipCategoryID: Int?
    var image, tipCategoryTitle: String?
    var views: Int?
    var drugGroups: [DrugGroup]?

    enum CodingKeys: String, CodingKey {
        case id, title, description, date
        case tipCategoryID = "tipCategoryId"
        case image, tipCategoryTitle, views, drugGroups
    }
}

// MARK: - DrugGroup -
struct DrugGroup: Codable {
    var id,order: Int?
    var title: String?
}

extension TipDetailsM {
    var formattedDate: String? {
        return date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd / MM / yyyy hh:mm a") ?? nil
    }
}
