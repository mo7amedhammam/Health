//
//  PackageFilesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/05/2025.
//

import Foundation

@MainActor
class PackageFilesViewModel:ObservableObject {
    static let shared = PackageFilesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0

    var CustomerPackageId : Int?
    // Published properties
    @Published var packageFiles : PackageFileM?
    @Published var customerMyFiles : [customerMyFileM]?
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension PackageFilesViewModel{
    
    @MainActor
    func getSubscripedPackageFiles() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerPackageId = CustomerPackageId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        
        let target = SubscriptionServices.GetCustomerPackageInstructionByCPId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: PackageFileM.self
            )
            await MainActor.run{
                self.packageFiles = response
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getCustomerSubscripedPackageFiles() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerPackageId = CustomerPackageId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        
        let target = SubscriptionServices.GetCustomerPackageInstructionByCPId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [customerMyFileM].self
            )
                self.customerMyFiles = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
