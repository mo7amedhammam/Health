//
//  MeasurementServices.swift
//  Health
//
//  Created by Hamza on 08/09/2023.
//

import Foundation
import Alamofire


enum Measurement {
    case GetMyMeasurementsStats
    
}

extension Measurement : TargetType {
    var path: String {
        switch self {
        case .GetMyMeasurementsStats:
            return EndPoints.MyMeasurementsStats.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetMyMeasurementsStats:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetMyMeasurementsStats:
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

