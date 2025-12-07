//
//  TicketViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 22/05/2025.
//

import Foundation

class TicketViewModel:ObservableObject {
    static let shared = PackageMoreDetailsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
    
    var doctorId:Int                      = 0
    @Published var newDate                = Date()
    @Published var couponeCode                = ""

    // Published properties
    @Published var ticketData: TicketM? = nil
    @Published var availableDays: [AvailableDayM]?
    @Published var availableShifts: [AvailableTimeShiftM]?
    @Published var availableScheduals: [AvailableSchedualsM]? 
    
    @Published var selectedDay: AvailableDayM?
    @Published var selectedShift: AvailableTimeShiftM?
    @Published var selectedSchedual: AvailableSchedualsM?

    @Published var showSuccess:Bool = false

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension TicketViewModel{
    
    @MainActor
    func createCustomerPackage(paramters:[String:Any]?) async {
        isLoading = true
        defer { isLoading = false }
        guard let paramters = paramters else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        var parametersarr : [String : Any] = paramters
        if let doctorName = ticketData?.doctorData?.doctorName {
            parametersarr["doctorName"] = doctorName
        }
        if couponeCode.count > 0{
            parametersarr["coupon"] = couponeCode
        }
        
//        parametersarr["customerPackageId"] = ticketData?.packageData?.appCountryPackageId
//        parametersarr["appCountryPackageId"] = ticketData?.packageData?.appCountryPackageId
        parametersarr["totalAfterDiscount"] = ticketData?.packageData?.priceAfterDiscount
        parametersarr["doctorPackageId"] = nil

print(parametersarr)
        let target = HomeServices.CreateCustomerPackage(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: TicketM.self
            )
            showSuccess = true
//            self.ticketData = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
//    func prepareParamters()->[String : Any]? {
//        guard let packageId = packageDetails?.packageData?.packageID  ,let doctorId = packageDetails?.doctorData?.doctorID,let shiftId = selectedShift?.id,let doctorPackageId = doctorPackageId ,let totalAfterDiscount = packageDetails?.packageData?.priceAfterDiscount , let timeFrom = selectedSchedual?.timefrom ,let timeTo = selectedSchedual?.timeTo  else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return nil
//        }
//     return ["date":"\(newDate.formatted(.customDateFormat("YYYY-MM-dd")))","packageId":packageId,"doctorId":doctorId,"doctorPackageId":doctorPackageId,"shiftId":shiftId,"totalAfterDiscount":totalAfterDiscount,"timeFrom":timeFrom,"timeTo":timeTo]
//    }
}
