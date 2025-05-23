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
    
    // -- Add Record --
    var TestImage:UIImage?
    var TestPdf:URL?
    var Date:String? // required
//    var CustomerId : Int? = Helper.shared.getUser()?.id // required
    var addresponseModel: InbodyListItemM? = InbodyListItemM()
    
}

//MARK: -- Functions --
extension InbodyListVM{
    
    func GetCustomerInbodyList(completion: @escaping (EventHandler?) -> Void) {
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
                } else {
                    self?.responseModel?.items?.append(contentsOf: response.data?.items ?? [])
                }
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
  
    
    func AddCustomerInbodyReport(fileType:FileType,progressHandler: @escaping (Double) -> Void,completion: @escaping (EventHandler?) -> Void) {
        
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
          backgroundTask = UIApplication.shared.beginBackgroundTask {
              UIApplication.shared.endBackgroundTask(backgroundTask)
              backgroundTask = .invalid
          }
        
        var  parametersarr: [String : Any] = [:]
        switch fileType {
        case .image:
            guard let selfile = TestImage, let Date = Date else {
                // Handle missing username or password
                return
            }
             parametersarr  =  ["TestFile" : selfile ,"Date" : Date]

        case .Pdf:
            guard let selfile = TestPdf, let Date = Date else {
                // Handle missing username or password
                return
            }
             parametersarr =  ["TestFile" : selfile ,"Date" : Date]

        }

        completion(.loading)
        // Create your API request with the username and password
        let target = Authintications.CreateCustomerInboy(parameters: parametersarr)

        DispatchQueue.global(qos: .background).async {
            
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
                case .failure(let error):
                    // Handle the error
                    print("Login failed: \(error.localizedDescription)")
                    completion(.error(0, "\(error.localizedDescription)"))
                }
                
            }
            
        }
        
        
        
        
        
    }
    
}
