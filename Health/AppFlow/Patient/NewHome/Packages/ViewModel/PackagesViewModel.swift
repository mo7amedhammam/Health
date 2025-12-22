//
//  PackagesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 15/05/2025.
//

import Foundation

@MainActor
class PackagesViewModel: ObservableObject {
    // Injected services
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private let wishlistManager: WishlistManaging
    private let env: AppEnvironmentProviding
    private var loadTask:Task<Void,Never>? = nil
    
    // Pagination
    var maxResultCount: Int = 10
    var subcategoryskipCount: Int      = 0
    var PackagesSkipCount: Int      = 0

    // Published properties
    @Published var subCategories: SubCategoriesM?
    @Published var selectedSubCategory: SubCategoryItemM?
    @Published var packages: FeaturedPackagesM?

    // Loading + error
    @Published var isLoading: Bool? = false            // kept for HUD compatibility
    @Published var isLoadingSubcategories: Bool = false
    @Published var isLoadingPackages: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String? = nil

    // Wishlist in-flight control
    @Published var inFlightWishlist: Set<Int> = []

    // Init with DI
    init(
        networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared,
        wishlistManager: WishlistManaging = WishListManagerAdapter(),
        env: AppEnvironmentProviding = HelperEnvironment()

    ) {
        self.networkService = networkService
        self.wishlistManager = wishlistManager
        self.env = env
    }
}

// MARK: - Public API
extension PackagesViewModel {

    // Orchestrates initial loading for a main category:
    // 1) load subcategories
    // 2) auto-select first
    // 3) load packages for it
    func loadInitial(mainCategoryId: Int) async {
        await getSubCategories(mainCategoryId: mainCategoryId)
        if selectedSubCategory == nil {
            selectedSubCategory = subCategories?.items?.first
        }
        if let subId = selectedSubCategory?.id {
            await getPackages(categoryId: subId, reset: true)
        }
    }

    func refresh(mainCategoryId: Int) async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            // Reset pagination and reload everything, but keep current data visible
            subcategoryskipCount = 0
            PackagesSkipCount = 0
            await loadInitial(mainCategoryId: mainCategoryId)
        }
        await loadTask?.value
    }

    // Backwards-compatible signature
    func getSubCategories(mainCategoryId:Int) async {
        isLoading = true
        isLoadingSubcategories = true
        defer {
            isLoadingSubcategories = false
            if !isLoadingPackages { isLoading = false }
        }

        let parameters: [String: Any] = [
            "parentId": mainCategoryId,
            "maxResultCount": maxResultCount,
            "skipCount": subcategoryskipCount,
            "appCountryId" : env.appCountryId()
        ]

        let target = HomeServices.GetSubCategoryByParentId(parameters: parameters)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(
                target,
                responseType: SubCategoriesM.self
            )
//            self.subCategories = response
            if subcategoryskipCount == 0 {
                // Initial load or reload: replace
                self.subCategories = response
            } else {
                // Pagination: append
                var current = self.subCategories ?? SubCategoriesM(items: [], totalCount: 0)
                let newItems = response?.items ?? []
                current.items = (current.items ?? []) + newItems
                current.totalCount = response?.totalCount ?? current.totalCount
                self.subCategories = current
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // Backwards-compatible signature (defaults to reset)
    func getPackages(categoryId:Int) async {
        await getPackages(categoryId: categoryId, reset: true)
    }

    // Supports reset/pagination; keeps existing data visible on refresh
    func getPackages(categoryId:Int, reset: Bool) async {
        // Guard against stale responses: remember which category we intended to load
        let intendedCategoryId = categoryId

        if reset {
            PackagesSkipCount = 0
            // Do NOT clear packages here; keep old data visible during refresh
        }

        isLoading = true
        if reset {
            isLoadingPackages = true
        } else {
            isLoadingMore = true
        }
        defer {
            if reset { isLoadingPackages = false } else { isLoadingMore = false }
            if !isLoadingSubcategories { isLoading = false }
        }

        var parameters: [String : Any] = [
            "categoryId": intendedCategoryId,
            "maxResultCount": maxResultCount,
            "skipCount": PackagesSkipCount
        ]
        // Apply environment: include appCountryId
        parameters["appCountryId"] = env.appCountryId()

        let target = HomeServices.GetPackageByCategoryId(parameters: parameters)
        do {
            self.errorMessage = nil
            let responseOpt = try await networkService.request(
                target,
                responseType: FeaturedPackagesM.self
            )

            // If the request was cancelled, the service returns nil — do not mutate state.
            guard let response = responseOpt else { return }

            // Ignore if user switched subcategory while we were loading
            guard selectedSubCategory?.id == intendedCategoryId else { return }

            if reset {
                self.packages = response
            } else {
                // Append for pagination
                var current = self.packages ?? FeaturedPackagesM(items: [], totalCount: 0)
                let newItems = response.items ?? []
                current.items = (current.items ?? []) + newItems
                current.totalCount = response.totalCount ?? current.totalCount
                self.packages = current
            }

            // Advance skipCount for next page
            let currentCount = self.packages?.items?.count ?? 0
            self.PackagesSkipCount = currentCount
        } catch {
            // Keep existing data; just surface the error
            self.errorMessage = error.localizedDescription
        }
    }

    func loadMoreSubcategoriesIfNeeded(mainCategoryId:Int) async {
        guard !isLoadingMore,
              let currentCount = subCategories?.items?.count,
              let totalCount = subCategories?.totalCount,
              currentCount < totalCount else { return }

        subcategoryskipCount = subcategoryskipCount + maxResultCount
        await getSubCategories(mainCategoryId:mainCategoryId )
    }
    
    func loadMorePAckagesIfNeeded(currentItem: FeaturedPackageItemM) async {
        guard !isLoadingMore,
              let currentCount = packages?.items?.count,
              let totalCount = packages?.totalCount,
              currentCount < totalCount,
        let subId = selectedSubCategory?.id else { return }

        subcategoryskipCount = subcategoryskipCount + maxResultCount
        await getPackages(categoryId: subId, reset: false)
    }
    // Pagination trigger when a cell appears
//    func loadMorePAckagesIfNeeded(currentItem: FeaturedPackageItemM) async {
//        guard
//            !isLoadingMore,
//            let total = packages?.totalCount,
//            let items = packages?.items,
//            items.count < total,
//            let last = items.last,
//            last == currentItem, // only when the last visible appears
//            let subId = selectedSubCategory?.id
//        else { return }
//
//        await getPackages(categoryId: subId, reset: false)
//    }

    // Optimistic wishlist toggle with in-flight protection + rollback on error
    func toggleWishlist(for appCountryPackageId: Int) async {
        guard !inFlightWishlist.contains(appCountryPackageId) else { return }
        inFlightWishlist.insert(appCountryPackageId)
        defer { inFlightWishlist.remove(appCountryPackageId) }

        // Find item index if present in current list
        let idx = packages?.items?.firstIndex(where: { $0.appCountryPackageId == appCountryPackageId })

        // Snapshot old value and optimistically flip
        if let index = idx {
            let old = packages?.items?[index].isWishlist ?? false
            packages?.items?[index].isWishlist = !old

            do {
                try await wishlistManager.addOrRemovePackageToWishList(packageId: appCountryPackageId)
            } catch {
                // Rollback and surface error
                packages?.items?[index].isWishlist = old
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        } else {
            // Item not currently in the local list; still sync server
            do {
                try await wishlistManager.addOrRemovePackageToWishList(packageId: appCountryPackageId)
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }
}
