//
//  AppointmentsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/06/2025.
//

import Foundation

class AppointmentsViewModel : ObservableObject {
    static let shared = AppointmentsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
   
    @Published var upcomingSession: UpcomingSessionM? = nil

    // Published properties
    @Published var appointments : AppointmentsM?
//    = AppointmentsM(items: [AppointmentsItemM.init(id: 0,
//                                                                                                doctorName: "أحمد سامي عبد الله",
//                                                                                                sessionDate: "2025-06-10T09:12:36.691Z",
//                                                                                                timeFrom: "03:22:00",
//                                                                                                packageName: "باقة الصحة العامة",
//                                                                                                categoryName: "استشفاء بعد مجهود أو إصابة",
//                                                                                                mainCategoryID: 0,
//                                                                                                mainCategoryName: "اللياقة البدنية",
//                                                                                                categoryID: 0,
//                                                                                                sessionMethod: "string",
//                                                                                                packageID: 0,
//                                                                                                dayName: "الإثنين")], totalCount: 3)
//    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension AppointmentsViewModel{
    
//    CustomerPackageId
    @MainActor
    func getUpcomingSession() async {
//        if Task.isCancelled { return }

//        isLoading = true
//        defer { isLoading = false }
        let target = HomeServices.GetUpcomingSession(parameters: [:])
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: UpcomingSessionM.self
            )
            self.upcomingSession = response
        } catch {
//            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getAppointmenstList() async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = HomeServices.CustomerSessionCalender(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: AppointmentsM.self
            )
            
            if skipCount == 0 {
                // Initial load or reload: replace
                self.appointments = response
            } else {
                // Pagination: append
                var current = self.appointments ?? AppointmentsM(items: [], totalCount: 0)
                let newItems = response?.items ?? []
                current.items = (current.items ?? []) + newItems
                current.totalCount = response?.totalCount ?? current.totalCount
                self.appointments = current
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}

extension AppointmentsViewModel {
    
    @MainActor
    func refresh() async {
        skipCount = 0
        isLoading = true
        defer { isLoading = false }

        async let upcommingsession: () = getUpcomingSession()
        async let appointmenstList: () = getAppointmenstList()

        await _ = (upcommingsession,appointmenstList)
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard isLoading == false,
              let currentCount = appointments?.items?.count,
              let totalCount = appointments?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await getAppointmenstList()
    }
    
    func clear() {
        skipCount = 0
        appointments = nil
    }
}
