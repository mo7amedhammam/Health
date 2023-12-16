//
//  HelpVM.swift
//  Sehaty
//
//  Created by Hamza on 16/12/2023.
//

import Foundation
import Alamofire



class HelpVM {
    
    var ArrHelp : [ModelHelp]? = []

    
    
    func GetMyHelp(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = HelpsEnuum.getHelps
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[ModelHelp]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                self?.ArrHelp = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
}



enum HelpsEnuum {
    case getHelps
}

extension HelpsEnuum : TargetType {
    var path: String {
        return EndPoints.getHelp.rawValue
    }
    var method: Alamofire.HTTPMethod {
        return .get
    }
    var parameter: parameterType {
        return .plainRequest
    }
}
