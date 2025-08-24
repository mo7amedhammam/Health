//
//  CustomerOrderDetailM.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/06/2025.
//


// MARK: - CustomerOrderDetailM
struct CustomerBallanceM: Codable {
    var balance: Double?

    enum CodingKeys: String, CodingKey {
        case balance
    }
}


// MARK: - CustomerOrderDetailM
struct CustomerOrderDetailM: Codable {
    var packageName: String?
    var customerPackageID: Int?
    var cancelReason, status, date: String?
    var amount, sessionCount, attendedSessionCount, remainingSessionCount: Int?

    enum CodingKeys: String, CodingKey {
        case packageName
        case customerPackageID = "customerPackageId"
        case cancelReason, status, date, amount, sessionCount, attendedSessionCount, remainingSessionCount
    }
}

extension CustomerOrderDetailM {
    var formattedDate: String? {
        guard let date = self.date else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy MMM dd")
        return formatedDate // fallback to original string if parsing fails
    }
}

//// MARK: - CustomerOrderRefundM
//struct CustomerOrderRefundM: Codable {
//    var packageName: String?
//    var customerPackageID: Int?
//    var cancelReason, status, date: String?
//    var amount, sessionCount, attendedSessionCount, remainingSessionCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case packageName
//        case customerPackageID = "customerPackageId"
//        case cancelReason, status, date, amount, sessionCount, attendedSessionCount, remainingSessionCount
//    }
//}
