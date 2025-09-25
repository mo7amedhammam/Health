//
//  NewHomeViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Foundation

final class NewHomeViewModel: ObservableObject {
    static let shared = NewHomeViewModel() // kept for other screens if they rely on it; NewHomeView creates its own instance

    // Injected services
    private let networkService: AsyncAwaitNetworkServiceProtocol
    // Wishlist manager (kept internal to avoid View coupling)
    private let wishlistManager = WishListManagerViewModel.shared

    // Pagination/state
    var maxResultCount: Int? = 5
    var skipCount: Int? = 0
    var FeaturedPackagesSkipCount: Int? = 0

    // Published outputs (read-only to the View)
    @Published private(set) var upcomingSession: UpcomingSessionM? = nil
    @Published private(set) var homeCategories: HomeCategoryM?
    @Published private(set) var myMeasurements: [MyMeasurementsStatsM]?
    @Published private(set) var featuredPackages: FeaturedPackagesM?
    @Published private(set) var mostBookedPackages: [FeaturedPackageItemM]?
    @Published private(set) var mostViewedPackages: [FeaturedPackageItemM]?

    @Published var isLoading: Bool? = false
    @Published var isError: Bool? = false
    @Published var errorMessage: String? = nil

    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

// MARK: - Public API
extension NewHomeViewModel {

    // Unified loader to minimize UI invalidations
    @MainActor
    func load() async {
        guard isLoading != true else { return }
        isLoading = true
        errorMessage = nil

        let appCountryId = Helper.shared.AppCountryId()
        let max = maxResultCount ?? 5
        let categoriesSkip = 0
        let featuredSkip = 0

        do {
            async let upc: UpcomingSessionM? = Helper.shared.CheckIfLoggedIn()
                ? networkService.request(HomeServices.GetUpcomingSession, responseType: UpcomingSessionM.self)
                : nil

            async let categories: HomeCategoryM? = networkService.request(
                HomeServices.GetAllHomeCategory(parameters: [
                    "maxResultCount": max,
                    "skipCount": categoriesSkip,
                    "appCountryId": appCountryId ?? 0
                ]),
                responseType: HomeCategoryM.self
            )

            async let measurements: [MyMeasurementsStatsM]? = networkService.request(
                HomeServices.GetMyMeasurementsStats,
                responseType: [MyMeasurementsStatsM].self
            )

            async let featured: FeaturedPackagesM? = networkService.request(
                HomeServices.FeaturedPackageList(parameters: [
                    "maxResultCount": max,
                    "skipCount": featuredSkip,
                    "appCountryId": appCountryId ?? 0
                ]),
                responseType: FeaturedPackagesM.self
            )

            async let mostViewed: [FeaturedPackageItemM]? = networkService.request(
                HomeServices.MostViewedPackage(parameters: [
                    "top": max,
                    "AppCountryId": appCountryId ?? 0
                ]),
                responseType: [FeaturedPackageItemM].self
            )

            // Single commit
            upcomingSession = try await upc
            homeCategories = try await categories
            myMeasurements = try await measurements
            featuredPackages = try await featured
            mostViewedPackages = try await mostViewed
            // Optionally also prefetch most booked
            mostBookedPackages = nil

        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }

        isLoading = false
        // reset pagination for a new load
        skipCount = 0
        FeaturedPackagesSkipCount = 0
    }

    enum MostCases {
        case MostBooked, MostViewed
    }

    @MainActor
    func getMostBookedOrViewedPackages(forcase: MostCases) async {
        let appCountryId = Helper.shared.AppCountryId()
        let top = maxResultCount ?? 5
        let parameters: [String: Any] = ["top": top, "AppCountryId": appCountryId ?? 0]

        let target: TargetType1 = {
            switch forcase {
            case .MostBooked:
                return HomeServices.MostBookedPackage(parameters: parameters)
            case .MostViewed:
                return HomeServices.MostViewedPackage(parameters: parameters)
            }
        }()

        do {
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
            errorMessage = error.localizedDescription
        }
    }

    // Intent: toggle wishlist in a specific source list and sync to server
    enum SourceList {
        case featured
        case mostViewed
        case mostBooked
    }

    @MainActor
    func toggleWishlist(for packageId: Int, in source: SourceList) async {
        // Update local state first for responsiveness
        switch source {
        case .featured:
            if var items = featuredPackages?.items,
               let idx = items.firstIndex(where: { $0.appCountryPackageId == packageId }) {
                items[idx].isWishlist?.toggle()
                featuredPackages?.items = items
            }
        case .mostViewed:
            if var list = mostViewedPackages,
               let idx = list.firstIndex(where: { $0.appCountryPackageId == packageId }) {
                list[idx].isWishlist?.toggle()
                mostViewedPackages = list
            }
        case .mostBooked:
            if var list = mostBookedPackages,
               let idx = list.firstIndex(where: { $0.appCountryPackageId == packageId }) {
                list[idx].isWishlist?.toggle()
                mostBookedPackages = list
            }
        }

        // Sync server
        await wishlistManager.addOrRemovePackageToWishList(packageId: packageId)
    }

    // Targeted refreshers kept for reuse if needed elsewhere
    @MainActor
    func getUpcomingSession() async {
        let target = HomeServices.GetUpcomingSession
        do {
            errorMessage = nil
            let response = try await networkService.request(target, responseType: UpcomingSessionM.self)
            self.upcomingSession = response
        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getHomeCategories() async {
        guard let maxResultCount = maxResultCount,
              let skipCount = skipCount,
              let appCountryId = Helper.shared.AppCountryId() else {
            errorMessage = "check inputs"
            return
        }
        let parametersarr: [String: Any] = ["maxResultCount": maxResultCount, "skipCount": skipCount, "appCountryId": appCountryId]

        let target = HomeServices.GetAllHomeCategory(parameters: parametersarr)
        do {
            errorMessage = nil
            let response = try await networkService.request(target, responseType: HomeCategoryM.self)
            self.homeCategories = response
        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getMyMeasurements() async {
        let target = HomeServices.GetMyMeasurementsStats
        do {
            errorMessage = nil
            let response = try await networkService.request(target, responseType: [MyMeasurementsStatsM].self)
            self.myMeasurements = response
        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getFeaturedPackages() async {
        guard let maxResultCount = maxResultCount,
              let FeaturedPackagesSkipCount = FeaturedPackagesSkipCount,
              let appCountryId = Helper.shared.AppCountryId() else {
            errorMessage = "check inputs"
            return
        }
        let parametersarr: [String: Any] = ["maxResultCount": maxResultCount, "skipCount": FeaturedPackagesSkipCount, "appCountryId": appCountryId]

        let target = HomeServices.FeaturedPackageList(parameters: parametersarr)
        do {
            errorMessage = nil
            let response = try await networkService.request(target, responseType: FeaturedPackagesM.self)
            self.featuredPackages = response
        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Pagination helpers (optional)
extension NewHomeViewModel {
    @MainActor
    func loadMoreCategoriesIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = homeCategories?.items?.count,
              let totalCount = homeCategories?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await getHomeCategories()
    }

    @MainActor
    func loadMoreFeaturedPackagesIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = featuredPackages?.items?.count,
              let totalCount = featuredPackages?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        FeaturedPackagesSkipCount = (FeaturedPackagesSkipCount ?? 0) + maxResultCount
        await getFeaturedPackages()
    }
}
