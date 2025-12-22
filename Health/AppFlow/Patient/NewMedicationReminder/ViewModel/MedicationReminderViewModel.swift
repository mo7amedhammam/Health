//
//  MedicationReminderViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/07/2025.
//

import Foundation

enum FrequencyUnit: String, CaseIterable {
    case day = "Days"
    case hour = "Hours"
}

class MedicationReminderViewModel:ObservableObject {
    static let shared = MedicationReminderViewModel()
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil
    
//    var customerId: Int?
    var maxResultCount: Int = 5
    @Published var skipCount: Int = 0
    @Published var ArrDrugs : [ModelGetDrugs]?
    @Published var selectedDrug : ModelGetDrugs?
    
    @Published var showAddSheet:Bool = false
    @Published var drugName: String = ""
    @Published var startDate: Date? = Date(){
        didSet{
            formattedDate = startDate?.formatDate(format: "yyyy-MM-dd") ?? ""
        }
    }
    @Published var formattedDate = ""
    @Published var startTime: Date? = Date(){
        didSet{
            formattedTime = startTime?.formatDate(format: "hh:mm a") ?? ""
        }
    }
    @Published var formattedTime = ""

    @Published var frequencyValue: String = ""
    @Published var frequencyUnit: FrequencyUnit = .day
    @Published var durationDays: String = ""
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?

    @Published var reminders: ModelNotification?
//    = ModelNotification(items: [ ItemNoti(
//        count: 3,
//        startDate: "2025-07-18T00:00:00",
//        days: 7,
//        endDate: "2025-07-28T00:00:00",
//        active: true,
//        doseTimeTitle: "12:00",
//        drugTitle: "Panadol" // change to true to test active
//    ),
//                                                                              ItemNoti(
//                                                                                  count: 6,
//                                                                                  startDate: "2025-06-18T00:00:00",
//                                                                                  days: 4,
//                                                                                  endDate: "2025-07-28T00:00:00",
//                                                                                  active: false,
//                                                                                  doseTimeTitle: "12:00",
//                                                                                  drugTitle: "Panadol cold and flo" // change to true to test active
//                                                                              )]
//                                                                              
////                                                                              ,ItemNoti(drugID: 1, doseTimeID: 2, count: 3, startDate: 2025-07-17T00:00:00, days: 6, endDate: 2025-07-28T00:00:00, doseQuantityID: 9, pharmacistComment: "", notification: false, timeIsOver: true, active: true, id: 11, customerPrescriptionID: 111, doseTimeTitle: "ff", doseQuantityTitle: "tt", doseQuantityValue: 9, drugTitle: " D T" ]
//                                                                     , totalCount: 3)
    
//    var Parameters =  [String : Any]()

    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    @MainActor
    func GetNotifications() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            //        guard let customerId = customerId else {return}
            let Parameters:[String: Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount ]
            
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            let target = NewNotificationServices.GetNotification(parameters: Parameters)
            
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: ModelNotification.self
                )
                
                if skipCount == 0 {
                    self.reminders = response
                }else{
                    self.reminders?.items?.append(contentsOf: response?.items ?? [])
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
        
    }
    
    @MainActor
    func GetDrugs() async {
        let target = NewNotificationServices.GetDrug
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [ModelGetDrugs].self
            )
            self.ArrDrugs = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

//    var ParametersCreate =  [String : Any]()
//    var drugId : Int?
//    var doseTimeId : Int?
//    var count : Int?
//    var days : Int?
//    var doseQuantityId : Int?
//    var customerId : Int?
//    var startDate : String?
//    var endDate : String?
//    var pharmacistComment : String?
//    var otherDrug : String?
//    var notification : Bool?
    
    @MainActor
    func CreateNotification() async {
             
        guard let count = Int(frequencyValue) , let days = Int(durationDays) , let startDate = startDate else {return}
        
        var Parameters:[String: Any] =  [ "count" : count , "days" : days , "notification" : true ]
 
        if let drugId = selectedDrug?.id{
            Parameters ["drugId"] = drugId
        }else{
            Parameters ["drugId"] = 0
            Parameters ["otherDrug"] = drugName
        }
        
        Parameters["doseTimeId"] = switch frequencyUnit {
        case .day:
             1
        case .hour:
             2
        }
        
        var combinedStartDate = startDate
        if let startTime = startTime {
            let calendar = Calendar.current
            let timeComponents = calendar.dateComponents([.hour, .minute], from: startTime)
            
            combinedStartDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: startDate) ?? startDate
        }
//        Parameters ["startDate"] = combinedStartDate
        Parameters["startDate"] = combinedStartDate.formatDate(format: "yyyy-MM-dd'T'HH:mm:ss")
        if let endDate = Calendar.current.date(byAdding: .day, value: days, to: startDate) {
            Parameters["endDate"] = endDate.formatDate(format: "yyyy-MM-dd")
        }
//        "doseQuantityId" : doseQuantityId , // nil
//        "pharmacistComment" : pharmacistComment , //nil
        print("Parameters:  ",Parameters)
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        let target = NewNotificationServices.CreateNotification(parameters: Parameters)

        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: ModelCreateNotification.self
            )
            showAddSheet = false
            await GetNotifications()
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }


//    func CreateNotification1(completion: @escaping (EventHandler?) -> Void) {
//     
////        guard let doseTimeId = doseTimeId , let count = count , let days = days , let doseQuantityId = doseQuantityId , let startDate = startDate ,  let endDate = endDate ,let  pharmacistComment = pharmacistComment , let notification = notification  else {return}
//        
////        ParametersCreate =  ["drugId" : drugId ,"doseTimeId" : doseTimeId , "count" : count , "days" : days  , "doseQuantityId" : doseQuantityId , "startDate" : startDate , "endDate" : endDate ,  "pharmacistComment" : pharmacistComment , "otherDrug" : otherDrug , "notification" : notification ]
//        
//
//        completion(.loading)
//        // Create your API request with the username and password
//        let target = NotificationServices.CreateNotification(parameters: ParametersCreate)
//        //print(parametersarr)
//        
//        // Make the API call using your APIManager or networking code
//        BaseNetwork.callApi(target, BaseResponse<ModelCreateNotification>.self) { result in
//            // Handle the API response here
//            switch result {
//            case .success(let response):
//                // Handle the successful response
//                print("request successful: \(response)")
//                if response.messageCode == 200 {
//                    completion(.success)
//                } else if response.messageCode == 401 {
//                    completion(.error(0,"\(response.message ?? "login again")"))
//                } else {
//                    completion(.error(0,"\(response.message ?? "server error")"))
//                }
//                
//            case .failure(let error):
//                // Handle the error
//                print("Login failed: \(error.localizedDescription)")
//                completion(.error(0, "\(error.localizedDescription)"))
//            }
//        }
//    }
    
    //.............................................
    //.............................................
    //.............................................

    
    
}


extension MedicationReminderViewModel {
    
    @MainActor
    func refresh() async {
        skipCount = 0
        isLoading = true
        defer { isLoading = false }
//        async let normalRang: () = fetchNormalRange()
        async let details: () = GetNotifications()

         _ = await (details)
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = reminders?.items?.count,
              let totalCount = reminders?.totalCount,
              currentCount < totalCount else { return }

        skipCount = (skipCount) + maxResultCount
        await GetNotifications()
    }
    
    func clear() {
        skipCount = 0
        reminders = nil
    }
}
