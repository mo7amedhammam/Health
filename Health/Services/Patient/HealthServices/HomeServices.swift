//
//  HomeServices.swift
//  Health
//
//  Created by wecancity on 05/09/2023.
//

import Foundation
import Alamofire

enum HomeServices{
    case GetDoseTimes
}

extension HomeServices: TargetType{
    var path: String {
        switch self {
        case .GetDoseTimes:
            return EndPoints.GetDoseTimes.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetDoseTimes:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetDoseTimes:
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
