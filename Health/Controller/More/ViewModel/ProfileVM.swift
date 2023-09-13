//
//  ProfileVM.swift
//  Health
//
//  Created by wecancity on 13/09/2023.
//

import Foundation

class ProfileVM {
    
    var responseModel: ProfileM? = ProfileM()
    
    init(){
        responseModel?.name = Helper.getUser()?.name
        responseModel?.mobile = Helper.getUser()?.mobile
    }
}

//MARK: -- Functions --
extension ProfileVM{
    func GetMyProfile(completion: @escaping (EventHandler?) -> Void) {
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.GetMyProfile
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ProfileM>.self) {[weak self] result in
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
