import Foundation
import SwiftUI

extension AppointmentsViewModel {
    @Published var fromDate: Date? {
        didSet { /* Optionally trigger refresh or mark dirty */ }
    }
    @Published var toDate: Date? {
        didSet { /* Optionally trigger refresh or mark dirty */ }
    }
    @Published var sortDirection: String? {
        didSet { /* Optionally trigger refresh or mark dirty */ }
    }
}

// Note: If these properties already exist in AppointmentsViewModel, this extension can be removed to avoid duplication.
