//
//  PackageMoreDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/05/2025.
//


import Foundation

class PackageMoreDetailsViewModel:ObservableObject {
    static let shared = PackageMoreDetailsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
    
//    var doctorId:Int                      = 0
    var doctorPackageId:Int?
    @Published var newDate                = Date()
    
    // Published properties
    @Published var packageDetails: PackageMoreDetailsM?
    @Published var availableDays: [AvailableDayM]?
    @Published var availableShifts: [AvailableTimeShiftM]?
    @Published var availableScheduals: [AvailableSchedualsM]? 
    
    @Published var selectedDay: AvailableDayM?
    @Published var selectedShift: AvailableTimeShiftM?
    @Published var selectedSchedual: AvailableSchedualsM?
    @Published var ticketData: TicketM?
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension PackageMoreDetailsViewModel{
    
    @MainActor
    func getDoctorPackageDetails() async {
        isLoading = true
        defer { isLoading = false }
        guard let doctorPackageId = doctorPackageId, let appCountryId = Helper.shared.AppCountryId() else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["Id":doctorPackageId,"AppCountryId":appCountryId ]
        
        let target = HomeServices.GetDoctorPackageById(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: PackageMoreDetailsM.self
            )
            self.packageDetails = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getAvailableDays() async {
        isLoading = true
        defer { isLoading = false }
        guard let doctorId = packageDetails?.doctorData?.doctorID,let appCountryId = Helper.shared.AppCountryId()  else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["date":"\(newDate.formatted(.customDateFormat("YYYY-MM-dd")))","doctorId":doctorId,"appCountryId":appCountryId]

        let target = HomeServices.GetDoctorAvailableDayList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AvailableDayM].self
            )
            self.availableDays = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getAvailableShifts() async {
        isLoading = true
        defer { isLoading = false }
        guard let AppCountryId = packageDetails?.packageData?.appCountryPackageId  else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["AppCountryId":AppCountryId]

        let target = HomeServices.GetTimeShiftScheduleList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AvailableTimeShiftM].self
            )
            self.availableShifts = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getAvailableScheduals() async {
        isLoading = true
        defer { isLoading = false }
        guard let appCountryId = packageDetails?.packageData?.appCountryPackageId ,let packageId = packageDetails?.packageData?.packageID  ,let doctorId = packageDetails?.doctorData?.doctorID,let shiftId = selectedShift?.id else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["appCountryId":appCountryId,"date":"\(newDate.formatted(.customDateFormat("YYYY-MM-dd")))","packageId":packageId,"doctorId":doctorId,"shiftId":shiftId]

        let target = HomeServices.GetAvailableDoctorSchedule(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AvailableSchedualsM].self
            )
            self.availableScheduals = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getBookingSession() async {
        isLoading = true
        defer { isLoading = false }
        guard let paramters = prepareParamters() else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] = paramters
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
    
    func prepareParamters()->[String : Any]? {
        guard let appCountryPackageId = packageDetails?.packageData?.appCountryPackageId ,let packageId = packageDetails?.packageData?.packageID ,let doctorId = packageDetails?.doctorData?.doctorID,let shiftId = selectedShift?.id,let doctorPackageId = doctorPackageId ,let totalAfterDiscount = packageDetails?.packageData?.priceAfterDiscount , let timeFrom = selectedSchedual?.timefrom ,let timeTo = selectedSchedual?.timeTo,let date = selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "YYYY-MM-dd") else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return nil
        }
        return ["date":date,"packageId":packageId,"doctorId":doctorId,"doctorPackageId":doctorPackageId,"shiftId":shiftId,"totalAfterDiscount":totalAfterDiscount,"timeFrom":timeFrom,"timeTo":timeTo
                ,"appCountryPackageId":appCountryPackageId]
    }
}
