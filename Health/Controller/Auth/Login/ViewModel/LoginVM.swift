////
////  LoginVM.swift
////  Health
////
////  Created by wecancity on 04/09/2023.
////
//
//import Foundation
//import FirebaseMessaging
//
//class LoginVM {
//    var mobile: String?
//    var password: String?
//
//    var usermodel: LoginM? = LoginM()
//
//    func login(completion: @escaping (EventHandler?) -> Void) {
//        guard let mobile = mobile, let password = password else {
//            // Handle missing username or password
//            return
//        }
//        let parametersarr : [String : Any] =  ["mobile" : mobile ,"password" : password]
//        completion(.loading)
//        // Create your API request with the username and password
//        let target = Authintications.Login(parameters: parametersarr)
//
//        // Make the API call using your APIManager or networking code
//        BaseNetwork.callApi1(target, BaseResponse<LoginM>.self) {[weak self] result in
//            // Handle the API response here
//            switch result {
//            case .success(let response):
//                // Handle the successful response
//                print("request successful: \(response)")
//
//                guard response.messageCode == 200 else {
//                    completion(.error(0, (response.message ?? "check validations")))
//                    return
//                }
//                DispatchQueue.main.async {
//                    self?.usermodel = response.data
//                    completion(.success)
//                }
//            case .failure(let error):
//                // Handle the error
//                print("Login failed: \(error.localizedDescription)")
//                completion(.error(0, "\(error.localizedDescription)"))
//            }
//
//        }
//    }
//
//    func R_CustomerFireBaseDeviceToken(completion: @escaping (EventHandler?) -> Void) {
//
//        var token  = ""
//
//        completion(.loading)
//        // Create your API request with the username and password
//        if Helper.shared.getFirebaseToken() == "" ||  Helper.shared.getFirebaseToken().isEmpty  {
//            if let Newtoken = Messaging.messaging().fcmToken {
//                token = Newtoken
//            }
//        } else {
//            token = Helper.shared.getFirebaseToken()
//        }
//        print("token : \(token)")
//
//        let target = Authintications.SendFireBaseDeviceToken(parameters: ["customerDeviceToken" : token])
//        // Make the API call using your APIManager or networking code
//        BaseNetwork.callApi(target, BaseResponse<MFirebase>.self) { result in
//            // Handle the API response here
//            switch result {
//            case .success(let response):
//                // Handle the successful response
//                print("request FireBase Device Token: \(response)")
//                guard response.messageCode == 200 else {
//                    completion(.error(0, (response.message ?? "")))
//                    return
//                }
//                completion(.success)
//            case .failure(let error):
//                // Handle the error
//                print("Login failed: \(error.localizedDescription)")
//                completion(.error(0, "\(error.localizedDescription)"))
//            }
//
//        }
//    }
//
//
//}


import Foundation
import FirebaseMessaging

protocol LoginViewModelProtocol {
    var mobile: String? { get set }
    var password: String? { get set }
    var usermodel: LoginM? { get }
    
    func login(completion: @escaping (Result<Void, Error>) -> Void)
    func registerFirebaseDeviceToken(completion: @escaping (Result<Void, Error>) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol {
    var mobile: String?
    var password: String?
    var usermodel: LoginM?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService1.shared) {
        self.networkService = networkService
    }
    
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let mobile = mobile, let password = password else {
            completion(.failure(LoginError.invalidCredentials))
            return
        }
        
        let parameters: [String: Any] = ["mobile": mobile, "password": password]
        
        let target = NewAuthontications.Login(parameters: parameters)
        
        networkService.request(target, responseType: BaseResponse<LoginM>.self) {[weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let response):
                    //                    print("Login successful. Token: \(response.data?.token ), User: \(response.data?.name)")
                    if response.messageCode == 200 {
                        self.usermodel = response.data
                        completion(.success(()))
                    } else {
                        completion(.failure(NetworkError.unknown(code: response.messageCode ?? 0, error: response.message ?? "")))
                    }
                case .failure(let error):
                    //                    print("Login failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
        }
    }
    
    func registerFirebaseDeviceToken(completion: @escaping (Result<Void, Error>) -> Void) {
        getDeviceToken { [weak self] token in
            let target = NewAuthontications.SendFireBaseDeviceToken(parameters: ["customerDeviceToken": token])
            
            self?.networkService.request(target, responseType: BaseResponse<MFirebase>.self) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if response.messageCode == 200 {
                        completion(.success(()))
                    } else {
                        completion(.failure(LoginError.serverError(message: response.message ?? "Unknown error")))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getDeviceToken(completion: @escaping (String) -> Void) {
        if let token = Messaging.messaging().fcmToken {
            completion(token)
        } else {
            completion(Helper.shared.getFirebaseToken())
        }
    }
}

enum LoginError: Error {
    case invalidCredentials
    case serverError(message: String)
}
