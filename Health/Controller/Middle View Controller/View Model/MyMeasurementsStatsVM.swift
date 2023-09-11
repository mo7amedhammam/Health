//
//  MyMeasurementsStatsVM.swift
//  Health
//
//  Created by Hamza on 08/09/2023.
//

import Foundation

class MyMeasurementsStatsVM {
    
    var ArrStats : [ModelMyMeasurementsStats]?
    
    func GetMeasurementsStats(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        completion(.loading)
        let target = Measurement.GetMyMeasurementsStats
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[ModelMyMeasurementsStats]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                if response.messageCode == 200 {
                    self?.ArrStats = response.data
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    // .........................
    var maxResultCount: Int?
    var skipCount: Int?
    var medicalMeasurementId: Int?
    var dateFrom: String?
    var dateTo: String?
    var ArrMeasurement: ModelMedicalMeasurements?
    var Parameters =  [String : Any]()
    
    
    func GetMyMedicalMeasurements(completion: @escaping (EventHandler?) -> Void) {
     
         Parameters =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount ,"medicalMeasurementId" : medicalMeasurementId]

        completion(.loading)
        // Create your API request with the username and password
        let target = Measurement.GetMyMedicalMeasurements(parameters: Parameters)
        //print(parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelMedicalMeasurements>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                
                if response.messageCode == 200 {
                    self?.ArrMeasurement = response.data
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
        }
    }
    
    
    //..................................................
    
    var ArrNormalRange : ModelMeasurementsNormalRange?
    
    func GetMeasurementNormalRange(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let Parameters : [String : Any] =  ["medicalMeasurementId" : medicalMeasurementId]

        completion(.loading)
        let target = Measurement.GetNormalRange(parameters: Parameters)
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelMeasurementsNormalRange>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                if response.messageCode == 200 {
                    self?.ArrNormalRange = response.data
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    //........................................
    
    var ParametersCreate =  [String : Any]()
    var customerId : Int?
    var value : String?
    var comment : String?
    var measurementDate : String?
    
    
    
    func CreateMedicalMeasurements(completion: @escaping (EventHandler?) -> Void) {
     
        ParametersCreate =  ["customerId" : customerId ,"value" : value ,"medicalMeasurementId" : medicalMeasurementId , "comment" : comment , "measurementDate" : measurementDate ]

        completion(.loading)
        // Create your API request with the username and password
        let target = Measurement.CreateMeasurement(parameters: ParametersCreate)
        //print(parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelCreateMeasurements>.self) { result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                if response.messageCode == 200 {
                    completion(.success)
                } else if response.messageCode == 401 {
                    completion(.error(0,"\(response.message ?? "login again")"))
                } else {
                    completion(.error(0,"\(response.message ?? "server error")"))
                }
                
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
        }
    }
    
    
    
    
}
