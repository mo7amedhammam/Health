//
//  Authintications.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import Foundation
import Alamofire

//enum OTPVerificationType{
//    case Registeration, ResetingPassword
//}
enum Authintications {
    case Register(parameters : [String:Any])
    case Login(parameters : [String:Any])

    case SendOtp(parameters : [String:Any])
    case VerifyOtp(parameters : [String:Any])

    case GetDistricts,GetGenders

    case ResetPassword(parameters : [String:Any])
    case ChangePassword(parameters:[String:Any])
}

extension Authintications : TargetType {
    var path: String {
        switch self {
        case .Register:
            return EndPoints.Register.rawValue
        case .Login:
            return EndPoints.Login.rawValue

        case .SendOtp:
            return EndPoints.sendOTP.rawValue
            
        case .VerifyOtp:
            return EndPoints.VerifyOTP.rawValue
            
        case .GetDistricts:
            return EndPoints.GetAllDistricts.rawValue
        case .GetGenders:
            return EndPoints.GetAllGenders.rawValue
            
        case .ResetPassword:
            return EndPoints.ResetPassword.rawValue
            
        case .ChangePassword:
            return EndPoints.ChangePassword.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Register,
                .Login,
                .SendOtp,
                .VerifyOtp,
                .ResetPassword,
                .ChangePassword:
            return .post
            
        case .GetDistricts,
                .GetGenders:
            return .get
    }
    }
    
    var parameter: parameterType {
        switch self {
        case .Register(let parameters),
                .Login(let parameters),
                .VerifyOtp(parameters: let parameters),
                .SendOtp(parameters: let parameters),
                .ResetPassword(parameters: let parameters),
                .ChangePassword(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            
        case .GetDistricts,
                .GetGenders:
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
