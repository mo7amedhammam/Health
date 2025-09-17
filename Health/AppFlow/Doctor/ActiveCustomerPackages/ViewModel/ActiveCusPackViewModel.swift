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
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
    
//    var doctorId:Int                      = 0
//    var doctorPackageId:Int?
//    @Published var newDate                = Date()
    
    // Published properties
    @Published var subscripedPackage: SubcripedPackageItemM?
    @Published var upcomingSession: UpcomingSessionM? = nil
    @Published var customerMeasurements: [MyMeasurementsStatsM]?

    @Published var subscripedSessions: SubcripedSessionsListM?
//    @Published var availableDays: [AvailableDayM]?
//    @Published var availableShifts: [AvailableTimeShiftM]?
//    @Published var availableScheduals: [AvailableSchedualsM]?
//
//    @Published var selectedDay: AvailableDayM?
//    @Published var selectedShift: AvailableTimeShiftM?
//    @Published var selectedSchedual: AvailableSchedualsM?
//    @Published var ticketData: TicketM?
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension ActiveCusPackViewModel{
    @MainActor
    func getSubscripedPackageDetails(CustomerPackageId:Int) async {
        isLoading = true
        defer { isLoading = false }

        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        
        let target = SubscriptionServices.GetCustomerPackageById(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SubcripedPackageItemM.self
            )
                self.subscripedPackage = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
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
//            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getCustomerMeasurements(CustomerPackageId:Int) async {
//        isLoading = true
//        defer { isLoading = false }
        let parametersarr : [String : Any] =  ["customerId":CustomerPackageId]

        let target = DocActivePackagesServices.GetCustomerMeasurements(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [MyMeasurementsStatsM].self
            )
            self.customerMeasurements = response
        } catch {
//            isError=true
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getSubscripedPackagesList(customerPackageId:Int?) async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount,let customerPackageId = customerPackageId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount,"customerPackageId":customerPackageId]
        
//        Filter
//        "sortDirection": "string",
//        "fromDate": "2025-07-20T09:21:48.207Z",
//        "toDate": "2025-07-20T09:21:48.207Z",

        
        let target = DocActivePackagesServices.GetCustomerPackageList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SubcripedSessionsListM.self
            )
            self.subscripedSessions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    

    
}
