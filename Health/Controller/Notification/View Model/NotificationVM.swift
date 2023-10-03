//
//  NotificationVM.swift
//  Health
//
//  Created by Hamza on 13/09/2023.
//

import Foundation


class NotificationVM {

    var maxResultCount: Int?
    var skipCount: Int?
    var customerId: Int?
    
    var ArrNotifications: ModelNotification?
    var Parameters =  [String : Any]()
    
    
    func GetNotifications(completion: @escaping (EventHandler?) -> Void) {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount ,let customerId = customerId else {return}
         Parameters =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount ,"customerId" : customerId]
        completion(.loading)
        // Create your API request with the username and password
        let target = NotificationServices.GetNotification(parameters: Parameters)
//        print(Parameters)
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelNotification>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                if response.messageCode == 200 {
                    if skipCount == 0 {
                        self?.ArrNotifications = response.data
                    }else{
                        self?.ArrNotifications?.items?.append(contentsOf: response.data?.items ?? [])
                    }
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
        }
    }
    
    //.............................................
    //.............................................
    var ArrDrugs = [ModelGetDrugs]()
    
    func GetDrugs(completion: @escaping (EventHandler?) -> Void) {
//        completion(.loading)
        let target = NotificationServices.GetDrug
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[ModelGetDrugs]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                if response.messageCode == 200 {
                    self?.ArrDrugs = response.data!
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
        }
    }
    
    
    //.............................................
    //.............................................

    var ParametersCreate =  [String : Any]()
    var drugId : Int?
    var doseTimeId : Int?
    var count : Int?
    var days : Int?
    var doseQuantityId : Int?
//    var customerId : Int?
    var startDate : String?
    var endDate : String?
    var pharmacistComment : String?
    var otherDrug : String?
    var notification : Bool?

    func CreateNotification(completion: @escaping (EventHandler?) -> Void) {
     
//        guard let drugId = drugId , let doseTimeId = doseTimeId , let count = count , let days = days , let doseQuantityId = doseQuantityId , let startDate = startDate ,  let endDate = endDate ,let  pharmacistComment = pharmacistComment , let notification = notification  else {return}
        
        ParametersCreate =  ["drugId" : drugId ,"doseTimeId" : doseTimeId , "count" : count , "days" : days  , "doseQuantityId" : doseQuantityId , "startDate" : startDate , "endDate" : endDate ,  "pharmacistComment" : pharmacistComment , "otherDrug" : otherDrug , "notification" : notification ]

        completion(.loading)
        // Create your API request with the username and password
        let target = NotificationServices.CreateNotification(parameters: ParametersCreate)
        //print(parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelCreateNotification>.self) { result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                if response.messageCode == 200 {
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
        }
    }
    
    //.............................................
    //.............................................
    //.............................................

    
    
}
