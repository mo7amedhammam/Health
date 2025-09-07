//
//  ProfileServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 06/07/2025.
//


import Alamofire
enum ProfileServices{
    case GetProfile
    case UpdateProfile(parameters : [String:Any])
    
}

extension ProfileServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    var path: String {
        switch self {
            
        case .GetProfile:
            return ProfileEndPoints.GetProfile.rawValue

        case .UpdateProfile:
            return ProfileEndPoints.UpdateProfile.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .UpdateProfile
            :
            return .post
            
        case
                .GetProfile
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .UpdateProfile(parameters: let parameter)
            :
////            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .GetProfile
            :
            return nil
        }
    }
    
    
}
