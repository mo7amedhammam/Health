//
//  MyMeasurementsStatsVM.swift
//  Health
//
//  Created by Hamza on 08/09/2023.
//

import Foundation

class MyMeasurementsStatsVM {
    
    var ArrMeasurement : [ModelMyMeasurementsStats]?
    
    func GetMeasurementsStats(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        completion(.loading)
        let target = Measurement.GetMyMeasurementsStats
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[ModelMyMeasurementsStats]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                if response.messageCode == 200 {
                    self?.ArrMeasurement = response.data
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
}
