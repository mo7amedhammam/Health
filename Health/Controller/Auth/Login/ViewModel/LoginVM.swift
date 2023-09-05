//
//  LoginVM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

import Foundation

class LoginVM {
    var mobile: String?
    var password: String?
    
    var usermodel: LoginM? = LoginM()
    
    func login(completion: @escaping (EventHandler?) -> Void) {
        guard let mobile = mobile, let password = password else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["mobile" : mobile ,"password" : password]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.Login(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<LoginM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 , response.data != nil else {
                    completion(.error((response.message ?? "check validations")))
                    return
                }
                
                self?.usermodel = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error("\(error.localizedDescription)"))
            }

        }
    }
    
}
