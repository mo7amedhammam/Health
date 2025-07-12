//
//  TipDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/07/2025.
//


import Foundation

class TipDetailsViewModel: ObservableObject {
    static let shared = TipDetailsViewModel()
    
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    @Published var isLoadingMore:Bool? = false

    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
    
    var tipId: Int? = 0
    
    @Published var tipsByCategory : TipsByCategoryM? = TipsByCategoryM()
    @Published var tipDetails : TipDetailsM? = TipDetailsM()
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
  
}

//MARK: -- Functions --
extension TipDetailsViewModel{
    
    @MainActor
    func GetTipsByCategory() async {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            self.errorMessage = "check_inputs".localized
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        print("param",parametersarr)

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.getTipsByCategory(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: TipsByCategoryM.self
            )
            if skipCount == 0 {
                tipsByCategory = response
            }else{
                tipsByCategory?.items?.append(contentsOf: response?.items ?? [])
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func GetTipDetails() async {
        guard let tipId = tipId else {
            // Handle missings
            self.errorMessage = "check_inputs".localized
            return
        }
        let parametersarr : [String : Any] =  ["Id" : tipId]
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.getTipDetails(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: TipDetailsM.self
            )
            self.tipDetails = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
