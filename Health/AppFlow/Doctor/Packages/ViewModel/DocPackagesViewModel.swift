//
//  DocPackagesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/09/2025.
//

import Foundation

class DocPackagesViewModel:ObservableObject {
    static let shared = DocPackagesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    // -- Get List --
    var maxResultCount: Int?              = 8
    @Published var skipCount: Int?        = 0
    
    // Published properties
    @Published var ActivePackages: DocPackagesM?
//    = SubcripedPackagesM(items: [SubcripedPackageItemM(customerPackageID: 2, docotrID: 2, status: "active", subscriptionDate: "", lastSessionDate: "", packageName: "nameeee", categoryName: "cateeee", mainCategoryName: "main cateee", doctorName: "doc doc", sessionCount: 4, attendedSessionCount: 2, packageImage: "", doctorSpeciality: "special", doctorNationality: "egegege", doctorImage: "", canCancel: true, canRenew: true )], totalCount: 1)
    
    @Published var showAddSheet : Bool = false
    @Published var MainCategories: [CategoriyListItemM]?
    @Published var selectedMainCategory: CategoriyListItemM?
//    {
//        didSet{
////            guard selectedMainCategory != nil else { return }
//            selectedSubCategory = nil
//            Task{ await getSubCategories()}
//    }}
    @Published var SubCategories: [CategoriyListItemM]?
    @Published var selectedSubCategory: CategoriyListItemM?
//    {
//        didSet{
////            guard selectedSubCategory != nil else { return }
//            SelectedPackage = nil
//        Task{ await getPackagesList()}
//    }}
    @Published var PackagesList: [SpecialityM]?
    @Published var SelectedPackage: SpecialityM?
    
    @Published var CountriesList : [AppCountryByPackIdM]?
    @Published var selectedCountry : AppCountryByPackIdM?
    
    @Published var showSuccess : Bool = false

    @Published var isLoading:Bool? = false
    @Published var canLoadMore:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension DocPackagesViewModel{
    
    @MainActor
    func getActivePackages() async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount,"isExpired":false]
        
        let target = DocPackagesServices.GetPackageDoctor(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: DocPackagesM.self
            )

            if skipCount == 0 {
                // Fresh load
               await MainActor.run(){
                   ActivePackages = response
                   print("subscripedPackages:",ActivePackages ?? .init())
                }
            } else {
                // Append for pagination
                if var existing = self.ActivePackages,
                   let newItems = response?.items {
                    existing.items?.append(contentsOf: newItems)
                    existing.totalCount = response?.totalCount
                    ActivePackages = existing
                }
            }
            canLoadMore = response?.items?.count ?? 0 < response?.totalCount ?? 0

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getMainCategories() async {
        isLoading = true
        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["parentId":mainCategoryId,"maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        
        let target = DocPackagesServices.GetMainCategoryDBForList
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [CategoriyListItemM].self
            )
            self.MainCategories = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    @MainActor
    func getSubCategories() async {
        isLoading = true
        defer { isLoading = false }
        guard let ParentId = selectedMainCategory?.id else {
//            // Handle missings
            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["parentId" : ParentId]
        
        let target = DocPackagesServices.GetSubCategoryForList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [CategoriyListItemM].self
            )
            self.SubCategories = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getPackagesList() async {
        isLoading = true
        defer { isLoading = false }
        guard let CategoryId = selectedSubCategory?.id else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["CategoryId":CategoryId]

        let target = DocPackagesServices.GetPackageForList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [SpecialityM].self
            )
            self.PackagesList = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getCountryByPackageId() async {
        isLoading = true
        defer { isLoading = false }
        guard let PackageId = SelectedPackage?.id else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["PackageId":PackageId]

        let target = DocPackagesServices.GetAppCountryByPackageId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AppCountryByPackIdM].self
            )
            self.CountriesList = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func CreatePackageRequest() async {
        isLoading = true
        defer { isLoading = false }
// paramter keys :  doctorId,packageId,appCountryIdList
        guard let packageId = SelectedPackage?.id ,let appCountryIdList = selectedCountry?.id else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["packageId":packageId,"appCountryIdList":appCountryIdList]

        let target = DocPackagesServices.CreateDoctorPackageRequest(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: FeaturedPackagesM.self
            )
            showAddSheet = false
            self.showSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

extension DocPackagesViewModel {
    
    @MainActor
    func refresh() async {
        skipCount = 0
        await getActivePackages()
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard (canLoadMore ?? false && isLoading == false),
              let currentCount = ActivePackages?.items?.count,
              let totalCount = ActivePackages?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await getActivePackages()
    }
    
    func clear() {
        ActivePackages = nil
        skipCount = 0
    }

    func removeSelections(){
        selectedMainCategory = nil
        SubCategories?.removeAll()
        selectedSubCategory = nil
        PackagesList?.removeAll()
        SelectedPackage = nil
    }
}
