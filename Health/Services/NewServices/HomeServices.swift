//
//  HomeServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Alamofire


enum HomeServices{
    case GetUpcomingSession
    case GetAllHomeCategory(parameters : [String:Any])

}

extension HomeServices : TargetType1 {
    var path: String {
        switch self {
        case .GetUpcomingSession:
            return newEndPoints.GetCustomerUpcomingSession.rawValue
    
        case .GetAllHomeCategory:
            return newEndPoints.GetAllHomeCategory.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetAllHomeCategory:
            return .post
            
        case
                .GetUpcomingSession:
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
            .GetAllHomeCategory(parameters: let parameter):
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
//                .GetDistricts,
//                .GetGenders,
                .GetUpcomingSession:
            return nil
        }
    }
    
}
