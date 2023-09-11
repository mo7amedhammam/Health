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
    case GetMyMedicalMeasurements(parameters : [String:Any])
    case GetNormalRange(parameters : [String:Any])
    case CreateMeasurement(parameters : [String:Any])

}

extension Measurement : TargetType {
     
    var path: String {
        switch self {
        case .GetMyMeasurementsStats:
            return EndPoints.MyMeasurementsStats.rawValue
        case .GetMyMedicalMeasurements:
            return EndPoints.MyMedicalMeasurements.rawValue
        case .GetNormalRange:
            return EndPoints.MeasurementNormalRange.rawValue
        case .CreateMeasurement:
            return EndPoints.CreateMeasurement.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetMyMeasurementsStats,
                .GetNormalRange:
            return .get
            
        case .GetMyMedicalMeasurements,
                .CreateMeasurement :
            return .post
            
        }
    }
    
        var parameter: parameterType {
            switch self {
            case .GetMyMeasurementsStats:
                return .plainRequest  // get
            case .GetMyMedicalMeasurements(parameters: let parameters) ,
                    .CreateMeasurement(parameters: let parameters ):
                return .parameterRequest(Parameters: parameters, Encoding: encoding) // post with parameter
            case .GetNormalRange(parameters: let parameters):
                return .BodyparameterRequest(Parameters: parameters, Encoding: encoding) // get with parameter
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
    
