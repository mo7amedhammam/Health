//
//  NewHomeViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Foundation

class NewHomeViewModel:ObservableObject {
    static let shared = NewHomeViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int? = 5
    var skipCount: Int?      = 0

    var FeaturedPackagesSkipCount: Int?      = 0
//    var skipCount: Int?      = 0

    
    // Published properties
    @Published var upcomingSession: UpcomingSessionM? = nil
    @Published var homeCategories: HomeCategoryM?
    @Published var myMeasurements: [MyMeasurementsStatsM]?
    @Published var featuredPackages: FeaturedPackagesM?
    @Published var mostBookedPackages: [FeaturedPackageItemM]?
    @Published var mostViewedPackages: [FeaturedPackageItemM]?

    @Published var isLoading:Bool? = false
    @Published var isError:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
//        Task {
//            await refresh()
//        }
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

//MARK: -- Functions --
extension NewHomeViewModel{
    
    @MainActor
    func getUpcomingSession() async {
//        if Task.isCancelled { return }

//        isLoading = true
//        defer { isLoading = false }
        let target = HomeServices.GetUpcomingSession
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: UpcomingSessionM.self
            )
            self.upcomingSession = response
        } catch {
            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getHomeCategories() async {
        // Check for cancellation
//        if Task.isCancelled { return }

//        isLoading = true
//        defer { isLoading = false }
        guard let maxResultCount = maxResultCount, let skipCount = skipCount,let appCountryId = Helper.shared.AppCountryId() else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount,"appCountryId":appCountryId]
        
        let target = HomeServices.GetAllHomeCategory(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: HomeCategoryM.self
            )
//            if !Task.isCancelled {
                self.homeCategories = response
//            }
        } catch {
//            if !Task.isCancelled {
            isError=true
                self.errorMessage = error.localizedDescription
//            }
        }
    }
    
    @MainActor
    func getMyMeasurements() async {
//        isLoading = true
//        defer { isLoading = false }
        
        let target = HomeServices.GetMyMeasurementsStats
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [MyMeasurementsStatsM].self
            )
            self.myMeasurements = response
        } catch {
            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getFeaturedPackages() async {
//        isLoading = true
//        defer { isLoading = false }
        guard let maxResultCount = maxResultCount, let FeaturedPackagesSkipCount = FeaturedPackagesSkipCount,let appCountryId = Helper.shared.AppCountryId() else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : FeaturedPackagesSkipCount,"appCountryId":appCountryId]

        let target = HomeServices.FeaturedPackageList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: FeaturedPackagesM.self
            )
            self.featuredPackages = response
        } catch {
            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    enum MostCases {
    case MostBooked, MostViewed
    }
    @MainActor
    func getMostBookedOrViewedPackages(forcase:MostCases) async {
//        isLoading = true
//        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let appCountryId = Helper.shared.AppCountryId() else {
            // Handle missings
            self.errorMessage = "check inputs"
            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["top" : maxResultCount,"AppCountryId":appCountryId ]
        var target = HomeServices.MostViewedPackage(parameters: parametersarr)
        
        switch forcase {
        case .MostBooked:
             target = HomeServices.MostBookedPackage(parameters: parametersarr)
        case .MostViewed:
             target = HomeServices.MostViewedPackage(parameters: parametersarr)
        }

        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [FeaturedPackageItemM].self
            )
            switch forcase {
            case .MostBooked:
//                self.mostBookedPackages = response
                self.mostViewedPackages = response

            case .MostViewed:
                self.mostViewedPackages = response
            }

        } catch {
            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
}

extension NewHomeViewModel {
    
    @MainActor
    func refresh() async {
        guard !(isLoading ?? true) else { return }
        // Cancel any existing tasks
        cancelAllTasks()

        isLoading = true // Set loading state
        errorMessage = nil
        skipCount = 0
        FeaturedPackagesSkipCount = 0
        
        
        // Create a parent task that will manage child tasks
              let refreshTask = Task {
                  // Use task groups for structured concurrency
                  await withTaskGroup(of: Void.self) { group in
                      // Add all requests as child tasks
                      if Helper.shared.CheckIfLoggedIn(){
                          group.addTask { await self.getUpcomingSession() }
                      }
                      group.addTask { await self.getHomeCategories() }
                      group.addTask { await self.getMyMeasurements() }
                      group.addTask { await self.getFeaturedPackages() }
                      group.addTask { await self.getMostBookedOrViewedPackages(forcase: .MostViewed) }
                      
                      // Wait for all tasks to complete
                      await group.waitForAll()
                  }
                  
                  isLoading = false
              }
              
              tasks.append(refreshTask)
          }
    

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

