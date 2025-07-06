////
////  SignUpVM.swift
////  Health
////
////  Created by wecancity on 04/09/2023.
////
//
//import Foundation
//
//class SignUpVM {
//    var name: String?
//    var mobile: String?
//    var password:String?
//    var genderId: Int?
//    var countryId: Int?
////    var pharmacyCode:String?
//
//    var responseModel: SignUpM?
////    var DistrictsArr: [DistrictM]?
////    var GendersArr: [DistrictM]?
//
//}
//
//
////MARK: -- finctions --
//extension SignUpVM {
//    
////    func SignUp(completion: @escaping (EventHandler?) -> Void) {
////        guard  let name = name, let mobile = mobile, let password = password else {
////            // Handle missing username or password
////            return
////        }
////        var parametersarr : [String : Any]
////        
////         parametersarr  =  ["name" : name,"mobile" : mobile ,"password" : password]
////
////        completion(.loading)
////        // Create your API request with the username and password
////        let target = Authintications.Register(parameters: parametersarr)
////        //print(parametersarr)
////        
////        // Make the API call using your APIManager or networking code
////        BaseNetwork.callApi(target, BaseResponse<SignUpM>.self) {[weak self] result in
////            // Handle the API response here
////            switch result {
////            case .success(let response):
////                // Handle the successful response
////                print("request successful: \(response)")
////
////                guard response.messageCode == 200 else {
////                    completion(.error(0, "\(response.message ?? "check validations")"))
////               return
////                }
////                self?.responseModel = response.data
////                completion(.success)
////
////            case .failure(let error):
////                // Handle the error
////                print("Login failed: \(error.localizedDescription)")
////                completion(.error(0, "\(error.localizedDescription)"))
////            }
////        }
////    }
//    
//    func CreateAccount() async throws{
//        guard let name = name, let mobile = mobile, let password = password,let countryId = countryId else {
//            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
//        }
//        var parametersarr : [String : Any]
//        parametersarr = ["name" : name,"mobile" : mobile ,"password" : password,"countryId" : countryId]
//
//        let target = Authintications.Register(parameters: parametersarr)
//                do{
//                    let response = try await BaseNetwork.shared.request(target, BaseResponse<SignUpM>.self)
//                    
//                    guard let model = response.data else {
//                        throw NetworkError.unknown(code: response.messageCode ?? 0, error: response.message ?? "")
//                    }
//                    responseModel = model
//                } catch {
//                    throw error
//                }
//        }
//    
//    
//}



import Foundation

final class SignUpVM: ObservableObject {
    // Inputs
    @Published var name: String = ""
    @Published var mobile: String = ""
    @Published var password: String = ""
    @Published var countryId: Int?
    @Published var genderId: Int?

    // Outputs
    @Published var responseModel: SignUpM?
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?

    func createAccount(onSuccess: @escaping () -> Void) {
        guard !name.isEmpty, !mobile.isEmpty, !password.isEmpty, let countryId = countryId, let genderId = genderId else {
            self.errorMessage = "تحقق من البيانات"
            return
        }

        let parameters: [String: Any] = [
            "name": name,
            "mobile": mobile,
            "password": password,
            "appCountryId": countryId,
            "genderId":genderId
        ]

        let target = Authintications.Register(parameters: parameters)
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await BaseNetwork.shared.request(target, BaseResponse<SignUpM>.self)
                guard let model = response.data else {
                    throw NetworkError.unknown(code: response.messageCode ?? 0, error: response.message ?? "خطأ")
                }
                await MainActor.run {
                    self.responseModel = model
                    self.isLoading = false
                    onSuccess()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
