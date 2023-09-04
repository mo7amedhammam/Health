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

    func SignUp(completion: @escaping (Bool,String) -> Void) {
        guard  let name = name, let mobile = mobile, let genderId = genderId,let districtId = districtId,let pharmacyCode = pharmacyCode else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["name" : name,"mobile" : mobile ,"genderId" : genderId,"districtId" : districtId,"pharmacyCode" : pharmacyCode]

        // Create your API request with the username and password
        let target = Authintications.Login(parameters: parametersarr)
        //print(parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<SignUpM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 , response.data != nil else {
                    completion(false,"\(response.message ?? "check validations")")
               return
                }
                self?.responseModel = response.data
                    completion(true,"")
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    func GetDistricts(completion: @escaping (Bool,String) -> Void) {
        // Create your API request with the username and password
        let target = Authintications.GetDistricts
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[DistrictM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 , response.data != nil else {
                    completion(false,"\(response.message ?? "check validations")")
               return
                }
                self?.DistrictsArr = response.data
                    completion(true,"")
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }

    
}
