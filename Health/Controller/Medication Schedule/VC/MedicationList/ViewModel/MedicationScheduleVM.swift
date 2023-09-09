//
//  MedicationScheduleVM.swift
//  Health
//
//  Created by wecancity on 09/09/2023.
//

import Foundation

class MedicationScheduleVM {
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    
    var responseModel: MedicationScheduleM? = MedicationScheduleM()
    
    func GetMySchedulePrescriptions(completion: @escaping (EventHandler?) -> Void) {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.GetMySchedulePrescriptions(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<MedicationScheduleM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                
                self?.responseModel = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
}
