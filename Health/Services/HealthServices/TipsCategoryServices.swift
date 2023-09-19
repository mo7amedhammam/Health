//
//  TipsCategoryServices.swift
//  Health
//
//  Created by wecancity on 16/09/2023.
//

import Foundation
import Alamofire

enum TipsCategoryServices {
    case GetAllMobile(parameters : [String:Any])
    case GetTipNewest
    case GetTipInterestYou
    case GetTipMostViewed
}


extension TipsCategoryServices: TargetType {
    var path: String {
        switch self {
        case .GetAllMobile:
            return EndPoints.GetAllMobile.rawValue
        case .GetTipNewest:
            return EndPoints.GetTipNewest.rawValue
        case .GetTipInterestYou:
            return EndPoints.GetTipInterestYou.rawValue
        case .GetTipMostViewed:
            return EndPoints.GetTipMostViewed.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
    
        case .GetAllMobile:
            return .post
        case .GetTipNewest,
                .GetTipInterestYou,
                .GetTipMostViewed:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetAllMobile(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: encoding)
        case .GetTipNewest,
                .GetTipInterestYou,
                .GetTipMostViewed:
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
