//
//  ForgetPasswordVM.swift
//  Health
//
//  Created by wecancity on 07/09/2023.
//

import Foundation
import Combine

class ForgetPasswordVM: ObservableObject {
    @Published var mobile: String = ""
    @Published var newPassword: String = ""
    
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess = false

    var responsemodel: ForgetPasswordM?
}

extension ForgetPasswordVM {
//    func ResetPassword() {
//        guard !mobile.isEmpty, !newPassword.isEmpty else {
//            errorMessage = "Mobile and new password must not be empty"
//            return
//        }
//
//        let parametersarr: [String: Any] = ["mobile": mobile, "newPassword": newPassword]
//        DispatchQueue.main.async {
//            self.isLoading = true
//            self.errorMessage = nil
//            self.isSuccess = false
//        }
////        completion(.loading)
//
//        let target = Authintications.ResetPassword(parameters: parametersarr)
//
//        BaseNetwork.callApi(target, BaseResponse<ForgetPasswordM>.self) { [weak self] result in
//            guard let self = self else { return }
//            // self.isLoading = false
//
//            switch result {
//            case .success(let response):
//                print("request successful: \(response)")
//                guard response.messageCode == 200 else {
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        self.errorMessage = response.message ?? "check validations"
//                    }
////                    completion(.error(0, self.errorMessage!))
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                }
//                DispatchQueue.main.async {
//                    self.isSuccess = true
//                    self.responsemodel = response.data
//                }
//                print("responsemodel: \(responsemodel)")
//
////                completion(.success)
//            case .failure(let error):
//                print("Reset password failed: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.errorMessage = error.localizedDescription
//                }
////                completion(.error(0, self.errorMessage!))
//            }
//        }
//    }
    
    @MainActor
    func ResetPassword() {
        guard !mobile.isEmpty, !newPassword.isEmpty else {
            errorMessage = "Mobile and new password must not be empty"
            return
        }

        let parametersarr: [String: Any] = ["mobile": mobile, "newPassword": newPassword]

        
        isLoading = true
        errorMessage = nil
        
        let target = Authintications.ResetPassword(parameters: parametersarr)

        BaseNetwork.callApi(target, BaseResponse<ForgetPasswordM>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    guard response.messageCode == 200 else {
                        self?.errorMessage = response.message ?? "Check validations"
                        return
                    }
                    self?.responsemodel = response.data
                    self?.isSuccess = true
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
