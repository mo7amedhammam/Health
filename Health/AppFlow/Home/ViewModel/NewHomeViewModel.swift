//
//  NewHomeViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Foundation

class NewHomeViewModel:ObservableObject {
    // Injected service
     private let networkService: AsyncAwaitNetworkServiceProtocol

    // -- Get List --
    var maxResultCount: Int? = 5
    var skipCount: Int?      = 0
          

     // Published properties
     @Published var upcomingSession: UpcomingSessionM? = nil
    @Published var homeCategories: HomeCategoryM?

     @Published var isLoading = false
     @Published var errorMessage: String? = nil

     // Init with DI
     init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
         self.networkService = networkService
     }
}

//MARK: -- Functions --
extension NewHomeViewModel{

    @MainActor
    func getUpcomingSession() async {
        isLoading = true
        defer { isLoading = false }
        let target = HomeServices.GetUpcomingSession
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: UpcomingSessionM.self
            )
            self.upcomingSession = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getHomeCategories() async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            self.errorMessage = "check inputs"
//            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        
        let target = HomeServices.GetAllHomeCategory(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: HomeCategoryM.self
            )
            self.homeCategories = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
}
