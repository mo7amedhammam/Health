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
    private var loadTask:Task<Void, Never>?=nil
    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
    @Published var ArrStats: [MyMeasurementsStatsM]?
    @Published var ArrMeasurement: ModelMedicalMeasurements?
    @Published var ArrNormalRange: ModelMeasurementsNormalRange?
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
        Task{
            if Helper.shared.CheckIfLoggedIn(){
                await fetchStats()
            }
        }
    }
    
    // MARK: - Fetch Measurement Stats
    @MainActor
    func fetchStats() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            
            let target = NewMeasurement.GetMyMeasurementsStats
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [MyMeasurementsStatsM].self
                )
                self.ArrStats = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
    
    func clear() {
        self.ArrStats = nil
        self.ArrMeasurement = nil
        self.ArrNormalRange = nil
    }
}
