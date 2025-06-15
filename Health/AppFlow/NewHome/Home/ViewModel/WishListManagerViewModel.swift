//
//  WishListManagerViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/06/2025.
//


import Foundation

class WishListManagerViewModel:ObservableObject {
    static let shared = WishListManagerViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    var packageId: Int?

    @Published var isDone:Bool? = false
    
//    @Published var isLoading:Bool? = false
//    @Published var isError:Bool? = false
//    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    // Add task tracking
       private var tasks: [Task<Void, Never>] = []
       
       // Cancel all ongoing tasks
       func cancelAllTasks() {
           tasks.forEach { $0.cancel() }
           tasks.removeAll()
       }
       
       deinit {
           cancelAllTasks()
       }
}
extension WishListManagerViewModel{
    @MainActor
    func addOrRemovePackageToWishList(packageId:Int) async {
//        isLoading = true
//        defer { isLoading = false }
        let parameters: [String: Any] = ["PackageId": packageId]
        let target = HomeServices.AddOrRemoveToWishList(parameters: parameters)
        do {
//            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: FeaturedPackageItemM.self
            )
            self.isDone = true
        } catch {
//            isError=true
//            self.errorMessage = error.localizedDescription
        }
    }
}
