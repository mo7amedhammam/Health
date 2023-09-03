//
//  Authintications.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import Foundation
import Alamofire

enum OTPVerificationType{
    case Registeration, ResetingPassword
}
enum Authintications {
    case Register(parameters : [String:Any])
    case VerifyCustomer(type:OTPVerificationType,parameters : [String:Any])
    case SendOtp(parameters : [String:Any])
    
    case Login(parameters : [String:Any])
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
        case .VerifyCustomer(let type,_):
            switch type {
            case .Registeration:
                return EndPoints.VerifyCustomer.rawValue
            case .ResetingPassword:
                return EndPoints.VerifyOTP.rawValue
            }
        case .SendOtp:
            return EndPoints.sendOTP.rawValue
        case .ResetPassword:
            return EndPoints.ResetPassword.rawValue
            
        case .ChangePassword:
            return EndPoints.ChangePassword.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Register,
                .VerifyCustomer,
                .SendOtp,
                .Login,
                .ResetPassword,
                .ChangePassword:
            return .post
    }
    }
    
    var parameter: parameterType {
        switch self {
        case .Register(let parameters),
                .VerifyCustomer(_,parameters: let parameters),
                .SendOtp(parameters: let parameters),
                .Login(let parameters),
                .ResetPassword(parameters: let parameters),
                .ChangePassword(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: encoding)
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
