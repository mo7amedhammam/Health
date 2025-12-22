//
//  WishListViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 14/06/2025.
//

import Foundation

class WishListViewModel:ObservableObject {
    static let shared = WishListViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil
    
    // Published properties
    @Published var WishList: [FeaturedPackageItemM]?
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension WishListViewModel{
    
    @MainActor
    func getWishList() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            isLoading = true
            defer { isLoading = false }
            //        guard let CustomerPackageId = CustomerPackageId else {
            ////            // Handle missings
            ////            self.errorMessage = "check inputs"
            ////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            //            return
            //        }
            //        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
            
            let target = HomeServices.GetWishList
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [FeaturedPackageItemM].self
                )
                self.WishList = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
    
}

extension WishListViewModel {
    
    @MainActor
    func refresh() async {
//        skipCount = 0
        await getWishList()
    }

//    @MainActor
//    func loadMoreIfNeeded() async {
//        guard !(isLoading ?? false),
//              let currentCount = appointments?.items?.count,
//              let totalCount = appointments?.totalCount,
//              currentCount < totalCount,
//              let maxResultCount = maxResultCount else { return }
//
//        skipCount = (skipCount ?? 0) + maxResultCount
//        await getAppointmenstList()
//    }
}
