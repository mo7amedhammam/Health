//
//  OtpVM.swift
//  Health
//
//  Created by wecancity on 06/09/2023.
//

import Foundation

class OtpVM {
    var mobile: String?
    var EnteredOtp: String?
    
    var responseModel : OtpM? = OtpM()
    
    func SendOtp(completion: @escaping (EventHandler?) -> Void) {
        guard let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["mobile" : mobile ]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.SendOtp(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<OtpM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
//                    completion(.error((response.message ?? "check validations")))
                    completion(.error(response.messageCode, response.message ?? "check validations"))

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
    
    func VerifyOtp(completion: @escaping (EventHandler?) -> Void) {
        guard let otp = EnteredOtp ,let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["otp" : otp,"mobile" : mobile ]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.VerifyOtp(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<OtpM>.self) {[weak self] result in
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
