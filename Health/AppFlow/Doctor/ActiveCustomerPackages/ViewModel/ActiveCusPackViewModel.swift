//
//  ActiveCusPackViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/09/2025.
//

import Foundation

class ActiveCusPackViewModel:ObservableObject {
    static let shared = ActiveCusPackViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol

    // -- Pagination --
    var maxResultCount: Int? = 5
    var skipCount: Int? = 0

    // Published outputs (read-only to the view)
    @Published private(set) var subscripedPackage: SubcripedPackageItemM?
    @Published private(set) var upcomingSession: UpcomingSessionM? = nil
    @Published private(set) var customerMeasurements: [MyMeasurementsStatsM]?
    @Published private(set) var subscripedSessions: SubcripedSessionsListM?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil

    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Public API --
extension ActiveCusPackViewModel {
    // Consolidated loader to minimize UI invalidations
    @MainActor
    func load(customerPackageId: Int) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        // Prepare targets
        let pkgTarget = SubscriptionServices.GetCustomerPackageById(parameters: ["CustomerPackageId": customerPackageId])
        let upcTarget = HomeServices.GetUpcomingSession
        let measTarget = DocActivePackagesServices.GetCustomerMeasurements(parameters: ["customerId": customerPackageId])

        let sessionsTarget: TargetType1? = {
            guard let max = maxResultCount, let skip = skipCount else { return nil }
            return DocActivePackagesServices.GetCustomerPackageList(
                parameters: ["maxResultCount": max, "skipCount": skip, "customerPackageId": customerPackageId]
            )
        }()

        do {
            async let pkg: SubcripedPackageItemM? = networkService.request(pkgTarget, responseType: SubcripedPackageItemM.self)
            async let upc: UpcomingSessionM? = networkService.request(upcTarget, responseType: UpcomingSessionM.self)
            async let meas: [MyMeasurementsStatsM]? = networkService.request(measTarget, responseType: [MyMeasurementsStatsM].self)

            var sessions: SubcripedSessionsListM? = subscripedSessions
            if let sessionsTarget {
                sessions = try await networkService.request(sessionsTarget, responseType: SubcripedSessionsListM.self)
            }

            let (p, u, m) = try await (pkg, upc, meas)

            // Single commit
            subscripedPackage = p
            upcomingSession = u
            customerMeasurements = m
            subscripedSessions = sessions
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func loadMoreSessions(customerPackageId: Int) async {
        let currentCount = subscripedSessions?.items?.count ?? 0
        let totalCount = subscripedSessions?.totalCount ?? .max
        guard currentCount < totalCount else { return }

        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        skipCount = currentCount

        guard let max = maxResultCount, let skip = skipCount else { return }
        let target = DocActivePackagesServices.GetCustomerPackageList(
            parameters: ["maxResultCount": max, "skipCount": skip, "customerPackageId": customerPackageId]
        )

        do {
            if let page: SubcripedSessionsListM = try await networkService.request(target, responseType: SubcripedSessionsListM.self) {
                var merged = subscripedSessions ?? SubcripedSessionsListM(items: [], totalCount: page.totalCount)
                merged.items = (merged.items ?? []) + (page.items ?? [])
                merged.totalCount = page.totalCount ?? merged.totalCount
                subscripedSessions = merged
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Keep granular refreshers for targeted updates
    @MainActor
    func getSubscripedPackageDetails(CustomerPackageId:Int) async {
        isLoading = true
        defer { isLoading = false }

        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        let target = SubscriptionServices.GetCustomerPackageById(parameters: parametersarr)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(target, responseType: SubcripedPackageItemM.self)
            self.subscripedPackage = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getUpcomingSession() async {
        let target = HomeServices.GetUpcomingSession
        do {
            self.errorMessage = nil
            let response = try await networkService.request(target, responseType: UpcomingSessionM.self)
            self.upcomingSession = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getCustomerMeasurements(CustomerPackageId:Int) async {
        let parametersarr : [String : Any] =  ["customerId":CustomerPackageId]
        let target = DocActivePackagesServices.GetCustomerMeasurements(parameters: parametersarr)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(target, responseType: [MyMeasurementsStatsM].self)
            self.customerMeasurements = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getSubscripedPackagesList(customerPackageId:Int?) async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount,let customerPackageId = customerPackageId else {
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount,"customerPackageId":customerPackageId]
        let target = DocActivePackagesServices.GetCustomerPackageList(parameters: parametersarr)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(target, responseType: SubcripedSessionsListM.self)
            self.subscripedSessions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
