//
//  InbodyM.swift
//  Health
//
//  Created by wecancity on 11/09/2023.
//

// MARK: - InbodyListM
struct InbodyListM: Codable {
   var items: [InbodyListItemM]?
   var totalCount: Int?
}

// MARK: - InbodyListItemM -
struct InbodyListItemM: Codable,Equatable {
   var id: Int?
   var testFile: String?
   var customerID: Int?
   var customerName,createdByName,comment, date: String?

   enum CodingKeys: String, CodingKey {
       case id
       case testFile = "test"
       case customerID = "customerId"
       case customerName,createdByName, date, comment
   }
}

