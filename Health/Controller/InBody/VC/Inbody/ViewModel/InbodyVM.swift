//
//  InbodyVM.swift
//  Health
//
//  Created by wecancity on 11/09/2023.
//

import Foundation
import UIKit

class InbodyListVM {
    // -- Get List --
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    
    var responseModel: InbodyListM? = InbodyListM()
    var cansearch = false
    
    // -- Add Record --
    var TestImage:UIImage?
    var TestPdf:UIImage?
    var Date:String?
    var CustomerId : Int? = Helper.getUser()?.id // required
    var addresponseModel: InbodyListItemM? = InbodyListItemM()

}

//MARK: -- Functions --
extension InbodyListVM{
    func GetCustomerInbodyList(completion: @escaping (EventHandler?) -> Void) {
        cansearch = false
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.GetCustomerInbody(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<InbodyListM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                if self?.skipCount == 0 {
                    self?.responseModel = response.data
                }else{
                    self?.responseModel?.items?.append(contentsOf: response.data?.items ?? [])
                }
                completion(.success)
                self?.cansearch = true
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
    
    func AddCustomerInbodyReport(fileType:FileType,progressHandler: @escaping (Double) -> Void,completion: @escaping (EventHandler?) -> Void) {
        cansearch = false
        var  parametersarr: [String : Any] = [:]
        switch fileType {
        case .image:
            guard let selfile = TestImage, let Date = Date,let CustomerId = CustomerId else {
                // Handle missing username or password
                return
            }
             parametersarr  =  ["TestFile" : selfile ,"Date" : Date,"CustomerId" : CustomerId]

        case .Pdf:
            guard let selfile = TestPdf, let Date = Date,let CustomerId = CustomerId else {
                // Handle missing username or password
                return
            }
             parametersarr =  ["TestFile" : selfile ,"Date" : Date,"CustomerId" : CustomerId]

        }

        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.CreateCustomerInboy(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.uploadApi(target, BaseResponse<InbodyListItemM>.self, progressHandler: { progress in
            progressHandler(progress)
        }) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                    self?.addresponseModel = response.data

                completion(.success)
                self?.cansearch = true
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
}
