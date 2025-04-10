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
    var password:String?
//    var genderId: Int?
//    var districtId: Int?
//    var pharmacyCode:String?

    var responseModel: SignUpM?
//    var DistrictsArr: [DistrictM]?
//    var GendersArr: [DistrictM]?

}


//MARK: -- finctions --
extension SignUpVM {
    
//    func SignUp(completion: @escaping (EventHandler?) -> Void) {
//        guard  let name = name, let mobile = mobile, let password = password else {
//            // Handle missing username or password
//            return
//        }
//        var parametersarr : [String : Any]
//        
//         parametersarr  =  ["name" : name,"mobile" : mobile ,"password" : password]
//
//        completion(.loading)
//        // Create your API request with the username and password
//        let target = Authintications.Register(parameters: parametersarr)
//        //print(parametersarr)
//        
//        // Make the API call using your APIManager or networking code
//        BaseNetwork.callApi(target, BaseResponse<SignUpM>.self) {[weak self] result in
//            // Handle the API response here
//            switch result {
//            case .success(let response):
//                // Handle the successful response
//                print("request successful: \(response)")
//
//                guard response.messageCode == 200 else {
//                    completion(.error(0, "\(response.message ?? "check validations")"))
//               return
//                }
//                self?.responseModel = response.data
//                completion(.success)
//
//            case .failure(let error):
//                // Handle the error
//                print("Login failed: \(error.localizedDescription)")
//                completion(.error(0, "\(error.localizedDescription)"))
//            }
//        }
//    }
    
    func CreateAccount() async throws{
        guard let name = name, let mobile = mobile, let password = password else {
            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
        }
        var parametersarr : [String : Any]
        parametersarr = ["name" : name,"mobile" : mobile ,"password" : password]

        let target = Authintications.Register(parameters: parametersarr)
                do{
                    let response = try await BaseNetwork.shared.request(target, BaseResponse<SignUpM>.self)
                    
                    guard let model = response.data else {
                        throw NetworkError.unknown(code: response.messageCode ?? 0, error: response.message ?? "")
                    }
                    responseModel = model
                } catch {
                    throw error
                }
        }
    
    
}
