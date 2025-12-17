//
//  SubcripedSessionsListM.swift
//  Sehaty
//
//  Created by mohamed hammam on 28/05/2025.
//


// MARK: - SubcripedSessionsListM
struct SubcripedSessionsListM: Codable {
    var items: [SubcripedSessionsListItemM]?
    var totalCount: Int?
}

// MARK: - SubcripedSessionsListItemM
struct SubcripedSessionsListItemM: Codable,Hashable {
    var date, dayName, timeFrom, timeTo: String?
}
extension SubcripedSessionsListItemM{
    var formattedDate :String? {
        guard let date = date else { return "" }
        return date.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo:"dd MMM yyyy")
    }
    
    var formattedTimeFrom :String? {
        guard let date = timeFrom else { return "" }
        return date.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")
    }
    var formattedTimeTo :String? {
        guard let date = timeFrom else { return "" }
        return date.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")
    }
}
