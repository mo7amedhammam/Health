//
//  LookUpsServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/06/2025.
//

import Foundation

//import Alamofire


enum LookUpsServices{
    case GetALlGenders
    case GetALlCountries
    case GetAllLanguages
    case GetAllFileTypes
    case GetAllSpecialities
}

extension LookUpsServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .GetALlGenders:
            return LookupsEndPoints.GetAllGenders.rawValue
            
        case .GetALlCountries:
            return LookupsEndPoints.GetAppCountryForList.rawValue
            
        case .GetAllLanguages:
            return LookupsEndPoints.GetAllLanguages.rawValue
            
        case .GetAllFileTypes:
            return LookupsEndPoints.GetAllFileTypes.rawValue
            
        case .GetAllSpecialities:
            return LookupsEndPoints.GetSpecialityForList.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
            //        case
            //                .CreateCustomerMessage
            //            :
            //            return .post
            
        case
                .GetALlGenders
            ,.GetALlCountries
            ,.GetAllLanguages
            ,.GetAllFileTypes
            ,.GetAllSpecialities
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
            //        case
            //                .GetMessage(parameters: let parameter)
            //            :
            ////            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            //            return  parameter
            
            //        case .GetMyScheduleDrugs(parameters: let parameters):
            //            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .GetALlGenders
            ,.GetALlCountries
            ,.GetAllLanguages
            ,.GetAllFileTypes
            ,.GetAllSpecialities
            :
            return nil
        }
    }
    
    
}
