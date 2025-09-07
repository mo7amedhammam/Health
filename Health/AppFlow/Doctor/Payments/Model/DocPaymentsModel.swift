//
//  DocPaymentsModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//

// MARK: - DocBalanceM
struct DocBallanceM: Codable {
    var total,totalPaid,totalNotPaid: Double?

    enum CodingKeys: String, CodingKey {
        case total,totalPaid,totalNotPaid
    }
}


// MARK: - DocOrderDetailM
struct DocOrderDetailM: Codable ,Hashable{
    var packageName: String?
    var creationDate: String?
    var sessionCount, usedSessionCount, remainingSessionCount: Int?
    enum CodingKeys: String, CodingKey {
        case packageName
        case creationDate, sessionCount, usedSessionCount, remainingSessionCount
    }
}

extension DocOrderDetailM {
    var formattedDate: String? {
        guard let date = self.creationDate else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy MMM dd")
        return formatedDate // fallback to original string if parsing fails
    }
}
