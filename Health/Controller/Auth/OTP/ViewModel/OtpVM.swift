//
//  OtpVM.swift
//  Health
//
//  Created by wecancity on 06/09/2023.
//

import Foundation
import Combine

class OtpVM : ObservableObject{
    var mobile: String?
    var EnteredOtp: String?
    
    var responseModel : OtpM? = OtpM()
    
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false

    func SendOtp(completion: @escaping (EventHandler?) -> Void){
        guard let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["mobile" : mobile ]
        isLoading = true
        errorMessage = nil

        // Create your API request with the username and password
        let target = Authintications.SendOtp(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<OtpM>.self) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.isLoading = false
                    guard response.messageCode == 200 else {
                        self?.errorMessage = response.message ?? "حدث خطأ"
                        return
                    }
                    
                    self?.responseModel = response.data
                    completion(.success)
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription

                }
            }
        }
    }
    
    func VerifyOtp(otpfor:otpCases){
        guard let otp = EnteredOtp ,let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["otp" : otp,"mobile" : mobile ]
        isLoading = true
        errorMessage = nil

        // Create your API request with the username and password
        let target = Authintications.VerifyOtp(otpfor: otpfor,parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<OtpM>.self) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.isLoading = false
                    guard response.messageCode == 200 else {
                        self?.errorMessage = response.message ?? "OTP غير صالح"
                        return
                    }
                    
                    self?.responseModel = response.data
                    self?.isSuccess = true
//                    completion(.success)
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription

                }
            }
        }
    }
    
}
