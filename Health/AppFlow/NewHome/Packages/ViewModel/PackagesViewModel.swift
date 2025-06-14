//
//  PackagesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/05/2025.
//


import Foundation

class PackagesViewModel:ObservableObject {
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int? = 5
    var skipCount: Int?      = 0
    
    // Published properties
    @Published var subCategories: SubCategoriesM?
    @Published var selectedSubCategory: SubCategoryItemM?
    @Published var packages: FeaturedPackagesM?

    @Published var isLoading : Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension PackagesViewModel{
    
    @MainActor
    func getSubCategories(mainCategoryId:Int) async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["parentId":mainCategoryId,"maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        
        let target = HomeServices.GetSubCategoryByParentId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SubCategoriesM.self
            )
            self.subCategories = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getPackages(categoryId:Int) async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["categoryId":categoryId,"maxResultCount" : maxResultCount ,"skipCount" : skipCount]

        let target = HomeServices.GetPackageByCategoryId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: FeaturedPackagesM.self
            )
            self.packages = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
}
