//
//  CancelSubscriptionViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/07/2025.
//

import Foundation

class CancelSubscriptionViewModel:ObservableObject {
    static let shared = CancelSubscriptionViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var customerPackageId: Int?              = 0
    var reason: String?

    @Published var isCancelled:Bool? = false

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension CancelSubscriptionViewModel{
    
    @MainActor
    func cancelSubscription() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerPackageId = customerPackageId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        var parametersarr : [String : Any] =  ["customerPackageId":CustomerPackageId]
        if let reason = reason{
            parametersarr["reason"] =  reason
        }
        let target = SubscriptionServices.CancelSubscription(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: PackageFileM.self
            )
//            self.packageFiles = response
            self.isCancelled = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
