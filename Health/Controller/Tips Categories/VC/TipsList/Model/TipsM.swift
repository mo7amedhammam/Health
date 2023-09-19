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
struct TipsAllItem: Codable {
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


