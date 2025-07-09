//
//  MyMeasurementsVM.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//

import Foundation

import Combine

class MyMeasurementsViewModel: ObservableObject {
    static let shared = MyMeasurementsViewModel()
    
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
    @Published var ArrStats: [ModelMyMeasurementsStats]?
    @Published var ArrMeasurement: ModelMedicalMeasurements?
    @Published var ArrNormalRange: ModelMeasurementsNormalRange?
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Fetch Measurement Stats
    @MainActor
    func fetchStats() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewMeasurement.GetMyMeasurementsStats
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [ModelMyMeasurementsStats].self
            )
            self.ArrStats = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
}
