//
//  NewHomeViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Foundation

// MARK: - Test seams

/// Abstraction for wishlist operations so we can mock/throw in unit tests.
protocol WishlistManaging {
    /// Add or remove a package from wishlist. Implementations may throw on failure.
    func addOrRemovePackageToWishList(packageId: Int) async throws
}

/// Adapter to existing singleton manager. If the underlying method doesn’t throw,
/// this adapter will never throw — tests can inject a throwing mock to exercise rollback.
struct WishListManagerAdapter: WishlistManaging {
    func addOrRemovePackageToWishList(packageId: Int) async throws {
        await WishListManagerViewModel.shared.addOrRemovePackageToWishList(packageId: packageId)
    }
}

/// Minimal environment wrapper for Helper.shared usage (login/country).
protocol AppEnvironmentProviding {
    func appCountryId() -> Int
    func isLoggedIn() -> Bool
}

struct HelperEnvironment: AppEnvironmentProviding {
    func appCountryId() -> Int { Helper.shared.AppCountryId() ?? 0 }
    func isLoggedIn() -> Bool { Helper.shared.CheckIfLoggedIn() }
}

// MARK: - ViewModel

@MainActor
final class NewHomeViewModel: ObservableObject {
    static let shared = NewHomeViewModel() // kept for other screens if they rely on it; NewHomeView creates its own instance

    // Injected services
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private let wishlistManager: WishlistManaging
    private let env: AppEnvironmentProviding
    
    // Serialize unified home load to avoid overlapping requests
    private var loadTask: Task<Void, Never>? = nil

    // Pagination/state
    var maxResultCount: Int = 5
    var HomeCategoriesSkipCount: Int = 0
    var FeaturedPackagesSkipCount: Int = 0

    // Published outputs (read-only to the View)
    @Published private(set) var upcomingSession: UpcomingSessionM? = nil
    @Published private(set) var homeCategories: HomeCategoryM?
    @Published private(set) var myMeasurements: [MyMeasurementsStatsM]?
    @Published private(set) var featuredPackages: FeaturedPackagesM?
    @Published private(set) var mostBookedPackages: [FeaturedPackageItemM]?
    @Published private(set) var mostViewedPackages: [FeaturedPackageItemM]?

    // UI flags
    @Published var isLoading: Bool? = false
    @Published var isError: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: Init

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
extension NewHomeViewModel {

    // Unified loader to minimize UI invalidations
    func load() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            // Guard isLoading is not necessary if we serialize, but keep it for UI flags
            if self.isLoading == true { return }
            self.isLoading = true
            self.isError = false
            self.errorMessage = nil

            let appCountryId = self.env.appCountryId()
            let max = self.maxResultCount
            let categoriesSkip = 0
            let featuredSkip = 0

            do {
                async let upc: UpcomingSessionM? = self.env.isLoggedIn()
                ? self.networkService.request(HomeServices.GetUpcomingSession(parameters: [:]), responseType: UpcomingSessionM.self)
                    : nil

                async let categories: HomeCategoryM? = self.networkService.request(
                    HomeServices.GetAllHomeCategory(parameters: [
                        "maxResultCount": max,
                        "skipCount": categoriesSkip,
                        "appCountryId": appCountryId
                    ]),
                    responseType: HomeCategoryM.self
                )

                if Helper.shared.getSelectedUserType() == .Customer{
                    async let measurements: [MyMeasurementsStatsM]? = self.networkService.request(
                        HomeServices.GetMyMeasurementsStats,
                        responseType: [MyMeasurementsStatsM].self
                    )
                    self.myMeasurements = try await measurements
                }

                async let featured: FeaturedPackagesM? = self.networkService.request(
                    HomeServices.FeaturedPackageList(parameters: [
                        "maxResultCount": max,
                        "skipCount": featuredSkip,
                        "appCountryId": appCountryId
                    ]),
                    responseType: FeaturedPackagesM.self
                )

                if Helper.shared.getSelectedUserType() == .Customer{
                    async let mostViewed: [FeaturedPackageItemM]? = self.networkService.request(
                        HomeServices.MostViewedPackage(parameters: [
                            "top": max,
                            "AppCountryId": appCountryId
                        ]),
                        responseType: [FeaturedPackageItemM].self
                    )
                    self.mostViewedPackages = try await mostViewed
                }
                
                // Single commit
                self.upcomingSession = try await upc
                self.homeCategories = try await categories
                if self.env.isLoggedIn(){  self.featuredPackages = try await featured }
                // Optionally also prefetch most booked
                self.mostBookedPackages = nil
            } catch is CancellationError {
                // Ignore cancellations; keep current state
            } catch {
                self.isError = true
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
            // reset pagination for a new load
            self.HomeCategoriesSkipCount = 0
            self.FeaturedPackagesSkipCount = 0
        }
        await loadTask?.value
    }

    enum MostCases {
        case MostBooked, MostViewed
    }

    func getMostBookedOrViewedPackages(forcase: MostCases) async {
        let appCountryId = env.appCountryId()
        let top = maxResultCount
        let parameters: [String: Any] = ["top": top, "AppCountryId": appCountryId]

        let target: TargetType1 = {
            switch forcase {
            case .MostBooked:
                return HomeServices.MostBookedPackage(parameters: parameters)
            case .MostViewed:
                return HomeServices.MostViewedPackage(parameters: parameters)
            }
        }()

        do {
            isError = false
            errorMessage = nil
            let response: [FeaturedPackageItemM]? = try await networkService.request(target, responseType: [FeaturedPackageItemM].self)
            switch forcase {
            case .MostBooked:
                self.mostBookedPackages = response
            case .MostViewed:
                self.mostViewedPackages = response
            }
        } catch {
            isError = true
//            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.errorMessage = error.localizedDescription

        }
    }

    // Intent: toggle wishlist in all lists that might contain the package and sync to server.
    enum SourceList {
        case featured
        case mostViewed
        case mostBooked
    }

    func toggleWishlist(for packageId: Int, in source: SourceList) async {
        // Snapshot current state for possible rollback
        let oldFeatured = featuredPackages?.items
        let oldMostViewed = mostViewedPackages
        let oldMostBooked = mostBookedPackages

        // Optimistically update local state across lists to keep them consistent
        toggleWishlistLocally(packageId: packageId)

        // Sync server. If this throws, roll back and surface the error.
        do {
            try await wishlistManager.addOrRemovePackageToWishList(packageId: packageId)
        } catch {
            // Rollback local state
            featuredPackages?.items = oldFeatured
            mostViewedPackages = oldMostViewed
            mostBookedPackages = oldMostBooked

            isError = true
//            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.errorMessage = error.localizedDescription

        }
    }

    // Targeted refreshers kept for reuse if needed elsewhere
    func getUpcomingSession() async {
        let target = HomeServices.GetUpcomingSession(parameters: [:])
        do {
            isError = false
            errorMessage = nil
            let response = try await networkService.request(target, responseType: UpcomingSessionM.self)
            self.upcomingSession = response
        } catch {
            isError = true
//            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.errorMessage = error.localizedDescription

        }
    }

    func getHomeCategories() async {
    let parametersarr: [String: Any] = [
        "maxResultCount": maxResultCount,
        "skipCount": HomeCategoriesSkipCount,
        "appCountryId": env.appCountryId()
    ]

    let target = HomeServices.GetAllHomeCategory(parameters: parametersarr)
    do {
        isError = false
        errorMessage = nil
        let response = try await networkService.request(target, responseType: HomeCategoryM.self)
        if HomeCategoriesSkipCount == 0 {
            // Initial load or reload: replace
            self.homeCategories = response
        } else {
            // Pagination: append
            var current = self.homeCategories ?? HomeCategoryM(items: [], totalCount: 0)
            let newItems = response?.items ?? []
            current.items = (current.items ?? []) + newItems
            current.totalCount = response?.totalCount ?? current.totalCount
            self.homeCategories = current
        }
    } catch {
        isError = true
//        errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        self.errorMessage = error.localizedDescription
    }
}

    func getMyMeasurements() async {
        guard Helper.shared.getSelectedUserType() == .Customer else{return}

        let target = HomeServices.GetMyMeasurementsStats
        do {
            isError = false
            errorMessage = nil
            let response = try await networkService.request(target, responseType: [MyMeasurementsStatsM].self)
            self.myMeasurements = response
        } catch {
            isError = true
//            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.errorMessage = error.localizedDescription
        }
    }

    func getFeaturedPackages() async {
        let parametersarr: [String: Any] = [
            "maxResultCount": maxResultCount,
            "skipCount": FeaturedPackagesSkipCount,
            "appCountryId": env.appCountryId()
        ]

        let target = HomeServices.FeaturedPackageList(parameters: parametersarr)
        do {
            isError = false
            errorMessage = nil
            let response = try await networkService.request(target, responseType: FeaturedPackagesM.self)
            if FeaturedPackagesSkipCount == 0 {
                // Initial load or reload: replace
                self.featuredPackages = response
            } else {
                // Pagination: append
                var current = self.featuredPackages ?? FeaturedPackagesM(items: [], totalCount: 0)
                let newItems = response?.items ?? []
                current.items = (current.items ?? []) + newItems
                current.totalCount = response?.totalCount ?? current.totalCount
                self.featuredPackages = current
            }
        } catch {
            isError = true
//            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            self.errorMessage = error.localizedDescription

        }
    }
}

// MARK: - Private helpers

private extension NewHomeViewModel {
    func toggleWishlistLocally(packageId: Int) {
        // Featured
        if var items = featuredPackages?.items,
           let idx = items.firstIndex(where: { $0.appCountryPackageId == packageId }) {
            items[idx].isWishlist = !(items[idx].isWishlist ?? false)
            featuredPackages?.items = items
        }
        // Most Viewed
        if var list = mostViewedPackages,
           let idx = list.firstIndex(where: { $0.appCountryPackageId == packageId }) {
            list[idx].isWishlist = !(list[idx].isWishlist ?? false)
            mostViewedPackages = list
        }
        // Most Booked
        if var list = mostBookedPackages,
           let idx = list.firstIndex(where: { $0.appCountryPackageId == packageId }) {
            list[idx].isWishlist = !(list[idx].isWishlist ?? false)
            mostBookedPackages = list
        }
    }
}

// MARK: - Pagination helpers (optional)
extension NewHomeViewModel {
    func loadMoreCategoriesIfNeeded() async {
        guard isLoading == false,
              let currentCount = homeCategories?.items?.count,
              let totalCount = homeCategories?.totalCount,
              currentCount < totalCount else { return }

        HomeCategoriesSkipCount = HomeCategoriesSkipCount + maxResultCount
        await getHomeCategories()
    }

    func loadMoreFeaturedPackagesIfNeeded() async {
        guard isLoading == false,
              let currentCount = featuredPackages?.items?.count,
              let totalCount = featuredPackages?.totalCount,
              currentCount < totalCount else { return }

        FeaturedPackagesSkipCount = FeaturedPackagesSkipCount + maxResultCount
        await getFeaturedPackages()
    }
}

