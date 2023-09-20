//
//  TipsM.swift
//  Health
//
//  Created by wecancity on 16/09/2023.
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
struct TipsNewestM: Codable {
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
    var items: [TipsNewestM]?
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
    var id: Int?
    var title: String?
}
