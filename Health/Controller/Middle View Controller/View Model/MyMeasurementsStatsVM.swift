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
                completion(.error(0,"\(error.localizedDescription)"))
            }
        }
    }
    
    func asyncGetMeasurementsStats() async throws -> [ModelMyMeasurementsStats]  {
        let target = Measurement.GetMyMeasurementsStats
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[ModelMyMeasurementsStats]>.self)
//                print("result.data",result.data ?? [])
                return result.data ?? []
            } catch {
                throw error
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
        guard let maxResultCount = maxResultCount, let skipCount = skipCount ,let medicalMeasurementId = medicalMeasurementId else {return}
         Parameters =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount ,"medicalMeasurementId" : medicalMeasurementId] // needs dateFrom and dateTo
        if dateFrom != nil {
            Parameters["dateFrom"] = dateFrom
        }
        if dateTo != nil {
            Parameters["dateTo"]   = dateTo
        }
        
        completion(.loading)
        // Create your API request with the username and password
        let target = Measurement.GetMyMedicalMeasurements(parameters: Parameters)
        print("Parameters",Parameters)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<ModelMedicalMeasurements>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                if response.messageCode == 200 {
                    if self?.skipCount == 0 {
                        self?.ArrMeasurement = response.data
                    }else{
                        self?.ArrMeasurement?.measurements?.items?.append(contentsOf: response.data?.measurements?.items ?? [])
                    }

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
        guard let medicalMeasurementId = medicalMeasurementId else {return}

        let Parameters : [String : Any] =  ["Id" : medicalMeasurementId]

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
                completion(.error(0,"\(error.localizedDescription)"))
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
     
        guard let value = value , let medicalMeasurementId = medicalMeasurementId , let comment = comment , let measurementDate = measurementDate else {return}
        ParametersCreate =  ["value" : value ,"medicalMeasurementId" : medicalMeasurementId , "comment" : comment , "measurementDate" : measurementDate ]

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
