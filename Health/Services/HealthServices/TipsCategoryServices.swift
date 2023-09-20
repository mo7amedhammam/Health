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
    
    case getTipsByCategory(parameters : [String:Any])
    case getTipDetails(parameters : [String:Any])
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
        case .getTipsByCategory:
            return EndPoints.GetByCategory.rawValue
        case .getTipDetails:
            return EndPoints.GetDetail.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetAllMobile,
                .getTipsByCategory:
            return .post
        case .GetTipNewest,
                .GetTipInterestYou,
                .GetTipMostViewed,
                .getTipDetails:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetAllMobile(parameters: let parameters),
                .getTipsByCategory(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: encoding)
        case .getTipDetails(parameters: let parameters):
            return .BodyparameterRequest(Parameters:parameters, Encoding: encoding)
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
