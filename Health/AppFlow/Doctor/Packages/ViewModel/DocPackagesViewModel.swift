//
//  DocPackagesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/09/2025.
//

import Foundation

class DocPackagesViewModel: ObservableObject {
    static let shared = DocPackagesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    private var loadTask : Task<Void, Never>? = nil
    // -- Get List --
    var maxResultCount: Int?              = 8
    @Published var skipCount: Int?        = 0
    
    // Published properties
    @Published var ActivePackages: DocPackagesM?
    
    @Published var showAddSheet: Bool = false{didSet{errorMessage=nil}}
    @Published var MainCategories: [CategoriyListItemM]?
    @Published var selectedMainCategory: CategoriyListItemM?
    
    @Published var SubCategories: [CategoriyListItemM]?
    @Published var selectedSubCategory: CategoriyListItemM?
    
    @Published var PackagesList: [SpecialityM]?
    @Published var SelectedPackage: SpecialityM?
    
    // Countries
    @Published var CountriesList: [AppCountryByPackIdM]?
    // Legacy single selection (keep if some screens still bind to it)
    @Published var selectedCountry: AppCountryByPackIdM?
    // New: multiple country selection
    @Published var selectedCountries: [AppCountryByPackIdM] = []
    
    @Published var showSuccess: Bool = false

    @Published var isLoading: Bool? = false
    @Published var canLoadMore: Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension DocPackagesViewModel {
    
    @MainActor
    func getActivePackages() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            isLoading = true
            defer { isLoading = false }
            guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
                return
            }
            let parametersarr: [String: Any] = [
                "maxResultCount": maxResultCount,
                "skipCount": skipCount,
                "isExpired": false
            ]
            
            let target = DocPackagesServices.GetPackageDoctor(parameters: parametersarr)
            do {
                self.errorMessage = nil
                let response = try await networkService.request(
                    target,
                    responseType: DocPackagesM.self
                )
                if skipCount == 0 {
//                    await MainActor.run {
                        ActivePackages = response
//                        print("subscripedPackages:", ActivePackages ?? .init())
//                    }
                } else {
                    if var existing = self.ActivePackages,
                       let newItems = response?.items {
                        existing.items?.append(contentsOf: newItems)
                        existing.totalCount = response?.totalCount
                        ActivePackages = existing
                    }
                }
                canLoadMore = (response?.items?.count ?? 0) < (response?.totalCount ?? 0)
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
            await loadTask?.value
        }
    }

    @MainActor
    func getMainCategories() async {
        isLoading = true
        defer { isLoading = false }
        
        let target = DocPackagesServices.GetMainCategoryDBForList
        do {
            self.errorMessage = nil
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
            self.errorMessage = "check inputs"
            return
        }
        let parametersarr: [String: Any] = ["parentId": ParentId]
        
        let target = DocPackagesServices.GetSubCategoryForList(parameters: parametersarr)
        do {
            self.errorMessage = nil
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
            self.errorMessage = "check inputs"
            return
        }
        let parametersarr: [String: Any] = ["CategoryId": CategoryId]

        let target = DocPackagesServices.GetPackageForList(parameters: parametersarr)
        do {
            self.errorMessage = nil
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
            self.errorMessage = "check inputs"
            return
        }
        let parametersarr: [String: Any] = ["PackageId": PackageId]

        let target = DocPackagesServices.GetAppCountryByPackageId(parameters: parametersarr)
        do {
            self.errorMessage = nil
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
        // param keys: doctorId (server-side inferred?), packageId, appCountryIdList
        
        guard let packageId = SelectedPackage?.id else {
            self.errorMessage = "check inputs"
            return
        }
        
        // Build array of selected country IDs.
        // Prefer multi-select; if empty and legacy single selection exists, wrap it.
        var countryIds: [Int] = selectedCountries.compactMap { $0.id }
        if countryIds.isEmpty, let singleId = selectedCountry?.id {
            countryIds = [singleId]
        }
        
        guard countryIds.isEmpty == false else {
            self.errorMessage = "Please select at least one country"
            return
        }
        
        let parametersarr: [String: Any] = [
            "packageId": packageId,
            "appCountryIdList": countryIds
        ]

        let target = DocPackagesServices.CreateDoctorPackageRequest(parameters: parametersarr)
        do {
            self.errorMessage = nil
            _ = try await networkService.request(
                target,
                responseType: FeaturedPackagesM.self
            )
            showAddSheet = false
            removeSelections()
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

    func removeSelections() {
        selectedMainCategory = nil
        SubCategories?.removeAll()
        selectedSubCategory = nil
        PackagesList?.removeAll()
        SelectedPackage = nil
        // Clear countries selections too
        selectedCountry = nil
        selectedCountries.removeAll()
    }
}
