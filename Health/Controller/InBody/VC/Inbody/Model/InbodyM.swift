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
struct InbodyListItemM: Codable,Hashable {
   var id: Int?
   var testFile,title: String?
   var customerID: Int?
   var customerName,createdByName,comment, date: String?

   enum CodingKeys: String, CodingKey {
       case id
       case testFile = "test"
       case customerID = "customerId"
       case customerName,createdByName, date, comment
       case title
   }
}
extension InbodyListItemM {
    var formattedCreationDate: String? {
        guard let date = self.date else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy/MM/dd hh:mm a")
        return formatedDate // fallback to original string if parsing fails
    }
}

