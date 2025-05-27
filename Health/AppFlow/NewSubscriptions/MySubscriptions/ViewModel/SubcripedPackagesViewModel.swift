//
//  PackageMoreDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/05/2025.
//
import Foundation

class SubcripedPackagesViewModel:ObservableObject {
    static let shared = SubcripedPackagesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
    
//    var doctorId:Int                      = 0
//    var doctorPackageId:Int?
//    @Published var newDate                = Date()
    
    // Published properties
    @Published var subscripedPackages: SubcripedPackagesM? = .init(items: [.init()])
//    @Published var availableDays: [AvailableDayM]?
//    @Published var availableShifts: [AvailableTimeShiftM]?
//    @Published var availableScheduals: [AvailableSchedualsM]? 
//    
//    @Published var selectedDay: AvailableDayM?
//    @Published var selectedShift: AvailableTimeShiftM?
//    @Published var selectedSchedual: AvailableSchedualsM?
//    @Published var ticketData: TicketM?
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension SubcripedPackagesViewModel{
    
    @MainActor
    func getSubscripedPackages() async {
        isLoading = true
        defer { isLoading = false }
        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = SubscriptionServices.GetCustomerPackageList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SubcripedPackagesM.self
            )
            self.subscripedPackages = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
