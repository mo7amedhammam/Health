//
//  DocSchedualesServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 01/12/2025.
//

import Alamofire

enum DocSchedualesServices{
    case GetDocSchedule
    case CreateDocSchedule(parameters : [String:Any])
    case DeleteDocSchedule(parameters : [String:Any])
}

extension DocSchedualesServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .GetDocSchedule:
            return DocEndPoints.GetDoctorSchedule.rawValue

        case .CreateDocSchedule:
            return DocEndPoints.CreateDoctorSchedule.rawValue

        case .DeleteDocSchedule:
            return DocEndPoints.DeleteSchedule.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .CreateDocSchedule
            :
            return .post
            
        case
                .GetDocSchedule
            ,.DeleteDocSchedule
//            ,.DocRefundDetail
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .CreateDocSchedule(parameters: let parameter)
            ,.DeleteDocSchedule(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .GetDocSchedule
            :
            return nil
        }
    }
    
    
}
