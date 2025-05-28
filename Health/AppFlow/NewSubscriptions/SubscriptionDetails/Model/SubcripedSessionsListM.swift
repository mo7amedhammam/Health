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
