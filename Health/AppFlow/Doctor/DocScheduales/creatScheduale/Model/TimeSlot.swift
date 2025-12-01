//
//  TimeSlot.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/08/2025.
//

struct SchedualeM: Codable {
    var id: Int?
    var fromStartDate, toEndDate: String?
}

struct TimeSlot: Hashable {
    let title: String
    let time: String
}
    
