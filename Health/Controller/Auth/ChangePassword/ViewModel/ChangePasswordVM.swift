//
//  ChangePasswordVM.swift
//  Health
//
//  Created by wecancity on 07/09/2023.
//

import Foundation

class ChangePasswordVM {
    var oldPassword: String?
    var newPassword: String?
    
    var responsemodel: ChangePasswordM?
    
}

extension ChangePasswordVM{
    func ChangePassword(completion: @escaping (EventHandler?) -> Void) {
        guard let oldPassword = oldPassword, let newPassword = newPassword else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["oldPassword" : oldPassword ,"newPassword" : newPassword]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.ChangePassword(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ChangePasswordM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                
                self?.responsemodel = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
}
