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
    
    // -- med sched --
    case GetMySchedulePrescriptions(parameters:[String:Any])
    case GetMyScheduleDrugs(parameters:[String:Any])
    
    // -- inbody --
    case GetCustomerInbody(parameters:[String:Any])
    case CreateCustomerInboy(parameters:[String:Any])
    
    // -- profile --
    case GetMyProfile
    case SendFireBaseDeviceToken(parameters : [String:Any])
    
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

            // -- schedual --
        case .GetMySchedulePrescriptions:
            return EndPoints.GetMySchedulePrescriptions.rawValue
        case .GetMyScheduleDrugs:
            return EndPoints.GetMyScheduleDrugs.rawValue


            // -- inbody --
        case .GetCustomerInbody:
            return EndPoints.GetCustomerInBody.rawValue
        case .CreateCustomerInboy:
            return EndPoints.CreateCustomerInBody.rawValue
        case .GetMyProfile:
            return EndPoints.GetMyProfile.rawValue

        case .SendFireBaseDeviceToken :
            return EndPoints.SendFireBaseDeviceToken.rawValue
        }


    }

    var method: HTTPMethod {
        switch self {
        case .Register,
                .Login,
                .SendOtp,
                .VerifyOtp,
                .ResetPassword,
                .ChangePassword,
                .GetMySchedulePrescriptions,
                .GetCustomerInbody,
                .CreateCustomerInboy ,
                .SendFireBaseDeviceToken :
            return .post

        case .GetDistricts,
                .GetGenders,
                .GetMyScheduleDrugs,
                .GetMyProfile:
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
                .ChangePassword(parameters: let parameters),
                .GetMySchedulePrescriptions(parameters: let parameters),
                .GetCustomerInbody(parameters: let parameters),
                .CreateCustomerInboy(parameters: let parameters) ,
                .SendFireBaseDeviceToken(let parameters) :
            return .parameterRequest(Parameters: parameters, Encoding: encoding)

        case .GetMyScheduleDrugs(parameters: let parameters):
            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)

        case .GetDistricts,
                .GetGenders,
                .GetMyProfile:
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


enum NewAuthontications {
    case Register(parameters : [String:Any])
    case Login(parameters : [String:Any])
    
    case SendOtp(parameters : [String:Any])
    case VerifyOtp(parameters : [String:Any])
    
    case GetDistricts,GetGenders
    
    case ResetPassword(parameters : [String:Any])
    case ChangePassword(parameters:[String:Any])
    
    // -- med sched --
    case GetMySchedulePrescriptions(parameters:[String:Any])
    case GetMyScheduleDrugs(parameters:[String:Any])
    
    // -- inbody --
    case GetCustomerInbody(parameters:[String:Any])
    case CreateCustomerInboy(parameters:[String:Any])
    
    // -- profile --
    case GetMyProfile
    case SendFireBaseDeviceToken(parameters : [String:Any])
    
}

extension NewAuthontications : TargetType1 {
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
            
            // -- schedual --
        case .GetMySchedulePrescriptions:
            return EndPoints.GetMySchedulePrescriptions.rawValue
        case .GetMyScheduleDrugs:
            return EndPoints.GetMyScheduleDrugs.rawValue
            
            
            // -- inbody --
        case .GetCustomerInbody:
            return EndPoints.GetCustomerInBody.rawValue
        case .CreateCustomerInboy:
            return EndPoints.CreateCustomerInBody.rawValue
        case .GetMyProfile:
            return EndPoints.GetMyProfile.rawValue
            
        case .SendFireBaseDeviceToken :
            return EndPoints.SendFireBaseDeviceToken.rawValue
        }
        
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .Register,
                .Login,
                .SendOtp,
                .VerifyOtp,
                .ResetPassword,
                .ChangePassword,
                .GetMySchedulePrescriptions,
                .GetCustomerInbody,
                .CreateCustomerInboy ,
                .SendFireBaseDeviceToken :
            return .post
            
        case .GetDistricts,
                .GetGenders,
                .GetMyScheduleDrugs,
                .GetMyProfile:
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case .Register(let parameter),
                .Login(let parameter),
                .VerifyOtp(parameters: let parameter),
                .SendOtp(parameters: let parameter),
                .ResetPassword(parameters: let parameter),
                .ChangePassword(parameters: let parameter),
                .GetMySchedulePrescriptions(parameters: let parameter),
                .GetCustomerInbody(parameters: let parameter),
                .CreateCustomerInboy(parameters: let parameter),
                .SendFireBaseDeviceToken(let parameter),
                .GetMyScheduleDrugs(parameters: let parameter):
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case .GetDistricts,
                .GetGenders,
                .GetMyProfile:
            return nil
        }
    }
    
}
