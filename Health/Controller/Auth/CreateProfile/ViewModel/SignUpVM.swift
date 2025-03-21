//
//  SignUpVM.swift
//  Health
//
//  Created by wecancity on 04/09/2023.
//

import Foundation

class SignUpVM {
    var name: String?
    var mobile: String?
    var genderId: Int?
    var districtId: Int?
    var pharmacyCode:String?
    
    var responseModel: SignUpM?
    var DistrictsArr: [DistrictM]?
    var GendersArr: [DistrictM]?

 
}


//MARK: -- finctions --
extension SignUpVM {
    func SignUp(completion: @escaping (EventHandler?) -> Void) {
        guard  let name = name, let mobile = mobile, let genderId = genderId,let districtId = districtId,let pharmacyCode = pharmacyCode else {
            // Handle missing username or password
            return
        }
        var parametersarr : [String : Any]
        
         parametersarr  =  ["name" : name,"mobile" : mobile ,"genderId" : genderId,"districtId" : districtId,"pharmacyCode" : pharmacyCode]
        
        if pharmacyCode != "" {
            parametersarr["pharmacyCode"] = pharmacyCode
        }

        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.Register(parameters: parametersarr)
        //print(parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<SignUpM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, "\(response.message ?? "check validations")"))
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
    
    func GetDistricts(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = Authintications.GetDistricts
        completion(.loading)
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[DistrictM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0,"\(response.message ?? "check validations")"))
               return
                }
                self?.DistrictsArr = response.data
                completion(.success)
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    func GetGenders(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = Authintications.GetGenders
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[DistrictM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0,"\(response.message ?? "check validations")"))
               return
                }
                self?.GendersArr = response.data
                completion(.success)
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
}
