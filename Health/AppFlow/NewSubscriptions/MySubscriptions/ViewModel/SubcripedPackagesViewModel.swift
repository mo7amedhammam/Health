//
//  PackageMoreDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/05/2025.
//
import Foundation

class SubcripedPackagesViewModel:ObservableObject {
    static let shared = SubcripedPackagesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0

    
    // Published properties
    @Published var subscripedPackages: SubcripedPackagesM?
//    = SubcripedPackagesM(items: [SubcripedPackageItemM(customerPackageID: 2, status: "active", subscriptionDate: "", lastSessionDate: "", packageName: "nameeee", categoryName: "cateeee", mainCategoryName: "main cateee", doctorName: "doc doc", docotrID: "2", sessionCount: 4, attendedSessionCount: 2, packageImage: "", doctorSpeciality: "special", doctorNationality: "egegege", doctorImage: "", canCancel: true, canRenew: true )], totalCount: 1)
    
    @Published var isLoading:Bool? = false
    @Published var canLoadMore:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension SubcripedPackagesViewModel{
    
    @MainActor
    func getSubscripedPackages() async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount,"isExpired":false]
        
        let target = SubscriptionServices.GetCustomerPackageList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SubcripedPackagesM.self
            )

            if skipCount == 0 {
                // Fresh load
                self.subscripedPackages = response
            } else {
                // Append for pagination
                if var existing = self.subscripedPackages,
                   let newItems = response?.items {
                    existing.items?.append(contentsOf: newItems)
                    existing.totalCount = response?.totalCount
                    self.subscripedPackages = existing
                }
            }
            canLoadMore = response?.items?.count ?? 0 < response?.totalCount ?? 0

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}

extension SubcripedPackagesViewModel {
    
//    @MainActor
    func refresh() async {
        skipCount = 0
        await getSubscripedPackages()
    }

//    @MainActor
    func loadMoreIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = subscripedPackages?.items?.count,
              let totalCount = subscripedPackages?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await getSubscripedPackages()
    }
    
    func clear() {
        subscripedPackages = nil
        skipCount = 0
    }
}
