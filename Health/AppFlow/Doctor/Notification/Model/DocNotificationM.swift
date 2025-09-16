//
//  NotificationItem.swift
//  Sehaty
//
//  Created by mohamed hammam on 24/08/2025.
//

import SwiftUI

struct DocNotificationM: Identifiable {
    let id = UUID()
    let userName: String?
    let message: String?
    let timeAgo: String?
    let avatarColor: Color?
}
