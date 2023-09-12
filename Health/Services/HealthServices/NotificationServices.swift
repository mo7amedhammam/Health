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
}


extension NotificationServices: TargetType {
    var path: String {
        switch self {
        case .GetNotification :
            return EndPoints.GetNotification.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetNotification :
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetNotification(parameters: let parameter) :
            return .parameterRequest(Parameters: parameter, Encoding: encoding)
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
