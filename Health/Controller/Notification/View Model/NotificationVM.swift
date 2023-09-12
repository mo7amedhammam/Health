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
        //print(parametersarr)
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelNotification>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                if response.messageCode == 200 {
                    self?.ArrNotifications = response.data
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
    
    
}
