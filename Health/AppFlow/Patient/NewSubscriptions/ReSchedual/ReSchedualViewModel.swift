//
//  ReSchedualViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 21/09/2025.
//

import Foundation

class ReSchedualViewModel:ObservableObject {
    static let shared = ReSchedualViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    @Published var skipCount: Int?        = 0
    
    @Published var doctorId:Int?
    @Published var doctorPackageId:Int?
    @Published var PackageId:Int?
    @Published var SessionId:Int?

    @Published var newDate                = Date()
    
    // Published properties
    @Published var packageDetails: PackageMoreDetailsM?
    @Published var availableDays: [AvailableDayM]?
    @Published var availableShifts: [AvailableTimeShiftM]?
    @Published var availableScheduals: [AvailableSchedualsM]?
    @Published var ReschedualRequests: [RescheduleRequestM]?
    
    @Published var selectedDay: AvailableDayM?
    @Published var selectedShift: AvailableTimeShiftM?
    @Published var selectedSchedual: AvailableSchedualsM?
    @Published var ticketData: TicketM?
    
    @Published var isReschedualed:Bool? = false
    @Published var isApprouved:Bool? = false

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    @Published var appcountryId: Int? = Helper.shared.AppCountryId()
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension ReSchedualViewModel{
    
    @MainActor
    func getDoctorPackageDetails() async {
        isLoading = true
        defer { isLoading = false }
        guard let doctorPackageId = doctorPackageId, let appCountryId = appcountryId else {
            return
        }
        let parametersarr : [String : Any] =  ["Id":doctorPackageId,"AppCountryId":appCountryId ]
        print("parametersarr",parametersarr)

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
        guard let appCountryId = appcountryId  else {
            return
        }
        // Prefer the tapped day; fall back to the month anchor (newDate)
        let selectedDayString = selectedDay?.date?.ChangeDateFormat(
            FormatFrom: "yyyy-MM-dd'T'HH:mm:ss",
            FormatTo: "yyyy-MM-dd"
        )
        let dateString = selectedDayString ?? newDate.formatted(.customDateFormat("yyyy-MM-dd"))
        
        var parametersarr : [String : Any] =  ["date": dateString, "appCountryId": appCountryId]
          
        if let doctorId = doctorId{
            parametersarr["doctorId"] = doctorId
        }else{
            if let doctorId = packageDetails?.doctorData?.doctorID{
                parametersarr["doctorId"] = doctorId
            }
        }
        
        print("parametersarr,",parametersarr)
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
        guard let AppCountryId = appcountryId  else {
            return
        }
        let parametersarr : [String : Any] =  ["AppCountryId":AppCountryId]
        print("parametersarr",parametersarr)

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
        guard let appCountryId = appcountryId ,let shiftId = selectedShift?.id else {
            return
        }
        // Prefer the tapped day; fall back to the month anchor (newDate)
        let selectedDayString = selectedDay?.date?.ChangeDateFormat(
            FormatFrom: "yyyy-MM-dd'T'HH:mm:ss",
            FormatTo: "yyyy-MM-dd"
        )
        let dateString = selectedDayString ?? newDate.formatted(.customDateFormat("yyyy-MM-dd"))
        
        var parametersarr : [String : Any] =  [
            "appCountryId": appCountryId,
            "date": dateString,
            "shiftId": shiftId
        ]

        if let doctorId = doctorId{
            parametersarr["doctorId"] = doctorId
        }else{
            if let doctorId = packageDetails?.doctorData?.doctorID{
                parametersarr["doctorId"] = doctorId
            }
        }
        if let PackageId = PackageId{
            parametersarr["packageId"] = PackageId
        }else{
            if let PackageId = packageDetails?.packageData?.packageID{
                parametersarr["packageId"] = PackageId
            }
        }
        
        print("parametersarr",parametersarr)
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
    func createCustomerPackage(paramters:[String:Any]?) async {
        isLoading = true
        isReschedualed = false
        defer { isLoading = false }
        guard let paramters =
                switch Helper.shared.getSelectedUserType(){
                case .Customer,.none:
                    prepareParamters()
                case .Doctor:
                    prepareParamtersByDoctor()
                }  else {
                    return
                }
        var parametersarr : [String : Any] = paramters
        if let doctorName = ticketData?.doctorData?.doctorName {
            parametersarr["doctorName"] = doctorName
        }
        
        print(parametersarr)
        let target = HomeServices.CreateCustomerPackage(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: TicketM.self
            )
            isReschedualed = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func rescheduleCustomerPackage() async { // request by customer or direct reschedual by doctor
        isLoading = true
        isReschedualed = false
        defer { isLoading = false }
        // Validate required selections; adjust keys as needed for your API
        guard let newDate = selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd"),
              let sessionId = SessionId,
              let newTimeFrom = selectedSchedual?.timefrom,
              let newTimeTo = selectedSchedual?.timeTo else {
            self.errorMessage = "check inputs"
            return
        }

        let parametersarr : [String : Any] =  ["sessionId":sessionId,"newDate":newDate,"newTimeFrom":newTimeFrom,"newTimeTo":newTimeTo]
        print("parametersarr",parametersarr)

        let target = HomeServices.rescheduleSession(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: [AvailableSchedualsM].self
            )
            isReschedualed = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getReschedualRequests() async {
        isLoading = true
        defer { isLoading = false }
        guard let appCountryId = appcountryId ,let shiftId = selectedShift?.id else {
            return
        }
        var parametersarr : [String : Any] =  ["appCountryId":appCountryId,"date":"\(newDate.formatted(.customDateFormat("yyyy-MM-dd")))","shiftId":shiftId]

        if let doctorId = doctorId{
            parametersarr["doctorId"] = doctorId
        }else{
            if let doctorId = packageDetails?.doctorData?.doctorID{
                parametersarr["doctorId"] = doctorId
            }
        }
        if let PackageId = PackageId{
            parametersarr["packageId"] = PackageId
        }else{
            if let PackageId = packageDetails?.packageData?.packageID{
                parametersarr["packageId"] = PackageId
            }
        }
        print("parametersarr",parametersarr)

        let target = HomeServices.GetReschedualRequestList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [RescheduleRequestM].self
            )
            self.ReschedualRequests = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func approuveCustomerRescheduleRequest() async { // approuve by doctor
        isLoading = true
        isReschedualed = false
        defer { isLoading = false }
        // Validate required selections; adjust keys as needed for your API
        guard let sessionId = selectedShift?.id else {
            self.errorMessage = "check inputs"
            return
        }

        let parametersarr : [String : Any] =  ["Id":sessionId]
        print("parametersarr",parametersarr)

        let target = HomeServices.ApprouveCustomerReschedualRequest(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: [AvailableSchedualsM].self
            )
            isApprouved = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    
    func prepareParamters()->[String : Any]? {
        guard let appCountryPackageId = packageDetails?.packageData?.appCountryPackageId ,let packageId = packageDetails?.packageData?.packageID ,let doctorId = packageDetails?.doctorData?.doctorID,let shiftId = selectedShift?.id,let doctorPackageId = doctorPackageId ,let totalAfterDiscount = packageDetails?.packageData?.priceAfterDiscount , let timeFrom = selectedSchedual?.timefrom ,let timeTo = selectedSchedual?.timeTo,let date = selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd") else {
            return nil
        }
        return ["date":date,"packageId":packageId,"doctorId":doctorId,"customerPackageId":doctorPackageId,"shiftId":shiftId,"totalAfterDiscount":totalAfterDiscount,"timeFrom":timeFrom,"timeTo":timeTo
                ,"appCountryPackageId":appCountryPackageId]
    }
    
    
    
//    @MainActor
    func prepareParamtersByDoctor() -> [String: Any]? {
//        "doctorName": "string",
//          "customerId": 0,
//          "customerPackageId": 0,
//          "packageId": 0,
//          "date": "2025-11-25T12:53:21.063Z",
//          "shiftId": 0,
//          "timeFrom": "string",
//          "timeTo": "string"
        // Ensure we read state on main actor
//        return MainActor.assumeIsolated { () -> [String: Any]? in
        print(packageDetails)
            guard
//                let appCountryPackageId = packageDetails?.appCountryPackageId,
                let packageId = PackageId,
                let customerId = doctorId,
                let shiftId = selectedShift?.id,
                let customerPackageId = doctorPackageId,
//                let totalAfterDiscount = packageDetails?.packageData?.priceAfterDiscount,
                let timeFrom = selectedSchedual?.timefrom,
                let timeTo = selectedSchedual?.timeTo,
                let date = selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd")
            else {
                return nil
            }

            return [
                "packageId": packageId,
                "customerId": customerId,
                "customerPackageId": customerPackageId,
                "shiftId": shiftId,
                "date": date,
                "timeFrom": timeFrom,
                "timeTo": timeTo,
                //                "totalAfterDiscount": totalAfterDiscount,
                //                "appCountryPackageId": appCountryPackageId
            ]
//        }
    }
}
