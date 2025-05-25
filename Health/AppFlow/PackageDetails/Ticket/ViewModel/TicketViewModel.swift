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
    
    // Published properties
    @Published var ticketData: TicketM? = .init()
    @Published var availableDays: [AvailableDayM]?
    @Published var availableShifts: [AvailableTimeShiftM]?
    @Published var availableScheduals: [AvailableSchedualsM]? 
    
    @Published var selectedDay: AvailableDayM?
    @Published var selectedShift: AvailableTimeShiftM?
    @Published var selectedSchedual: AvailableSchedualsM?

    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension TicketViewModel{
    
//    @MainActor
//    func createCustomerPackage(doctorPackageId:Int) async {
//        isLoading = true
//        defer { isLoading = false }
////        guard let doctorPackageId = doctor.packageDoctorID else {
//////            // Handle missings
//////            self.errorMessage = "check inputs"
//////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
////        }
//        let parametersarr : [String : Any] =  ["Id":doctorPackageId ]
//        
//        let target = HomeServices.GetDoctorPackageById(parameters: parametersarr)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: PackageMoreDetailsM.self
//            )
////            self.packageDetails = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }

//    @MainActor
//    func getAvailableDays() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let doctorId = packageDetails?.doctorData?.doctorID  else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["Date":"\(newDate.formatted(.customDateFormat("YYYY-MM-dd")))","DoctorId":doctorId]
//
//        let target = HomeServices.GetDoctorAvailableDayList(parameters: parametersarr)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [AvailableDayM].self
//            )
//            self.availableDays = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }

//    @MainActor
//    func getAvailableShifts() async {
//        isLoading = true
//        defer { isLoading = false }
////        guard let doctorId = packageDetails?.doctorData?.doctorID  else {
//////            // Handle missings
//////            self.errorMessage = "check inputs"
//////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
////        }
////        let parametersarr : [String : Any] =  ["Date":"\(selectedDate.formatted(.customDateFormat("YYYY-MM-dd")))","DoctorId":doctorId]
//
//        let target = HomeServices.GetTimeShiftScheduleList
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [AvailableTimeShiftM].self
//            )
//            self.availableShifts = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    
//    @MainActor
//    func getAvailableScheduals() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let packageId = packageDetails?.packageData?.packageID  ,let doctorId = packageDetails?.doctorData?.doctorID,let shiftId = selectedShift?.id else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["Date":"\(newDate.formatted(.customDateFormat("YYYY-MM-dd")))","packageId":packageId,"DoctorId":doctorId,"shiftId":shiftId]
//
//        let target = HomeServices.GetAvailableDoctorSchedule(parameters: parametersarr)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [AvailableSchedualsM].self
//            )
//            self.availableScheduals = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    
    
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
        
print(parametersarr)
        let target = HomeServices.GetBookingSession(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: TicketM.self
            )
            self.ticketData = response
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
