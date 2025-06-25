//
//  MyFilesServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//

import Alamofire
enum MyAllergiesServices{
    case AddAllergies(parameters : [String:Any])
    case GetAllergies
}

extension MyAllergiesServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .AddAllergies:
            return MyAllergiesEndPoints.AddCustomerAllergy.rawValue

        case .GetAllergies:
            return MyAllergiesEndPoints.GetCustomerAllergies.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .AddAllergies
            :
            return .post
            
        case
                .GetAllergies
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .AddAllergies(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .GetAllergies
            :
            return nil
        }
    }
    
    
}
