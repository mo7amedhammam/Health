//
//  ChangePasswordVM.swift
//  Health
//
//  Created by wecancity on 07/09/2023.
//

import Foundation
import Combine

class ChangePasswordVM: ObservableObject {
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess = false
    
    var responsemodel: ChangePasswordM?
    
    func changePassword() {
        guard !oldPassword.isEmpty, !newPassword.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        let parameters: [String: Any] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        isLoading = true
        errorMessage = nil
        
        let target = Authintications.ChangePassword(parameters: parameters)
        
        BaseNetwork.callApi(target, BaseResponse<ChangePasswordM>.self) { [weak self] result in
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
