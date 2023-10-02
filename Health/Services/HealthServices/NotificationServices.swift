//
//  NotificationServices.swift
//  Health
//
//  Created by Hamza on 13/09/2023.
//

import Foundation
import Alamofire

enum NotificationServices {
    case GetNotification(parameters : [String:Any])
    case CreateNotification (parameters : [String:Any])
    case GetDrug
}


extension NotificationServices: TargetType {
    var path: String {
        switch self {
        case .GetNotification :
            return EndPoints.GetNotification.rawValue
        case .CreateNotification(parameters: _):
            return EndPoints.CreateNotification.rawValue
        case .GetDrug:
            return EndPoints.GetDrug.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetNotification :
            return .post
        case .CreateNotification(parameters: _):
            return .post
        case .GetDrug:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetNotification(parameters: let parameter) :
            return .parameterRequest(Parameters: parameter, Encoding: encoding)
        case .CreateNotification(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: encoding)
        case .GetDrug:
            return .plainRequest
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

}
