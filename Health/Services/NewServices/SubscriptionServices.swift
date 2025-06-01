//
//  SubscriptionServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/05/2025.
//


import Alamofire


enum SubscriptionServices{
    case GetCustomerPackageList(parameters : [String:Any])
//    case GetCustomerPackageById(parameters : [String:Any])
//    case GetDoctorById(parameters : [String:Any])
//    case GetCustomerUpComingSession
    case GetCustomerPackageSessionList(parameters : [String:Any])
    case FileType
    case GetCustomerPackageInstructionByCPId(parameters : [String:Any])
//    case CreateDoctorMessage
//    case CreateCustomerMessage
//    case GetMessage
}

extension SubscriptionServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .GetCustomerPackageList:
            return SubscriptionEndPoints.GetCustomerPackageList.rawValue
//        case .GetCustomerPackageById:
//            return SubscriptionEndPoints.GetCustomerPackageById.rawValue
//        case .GetDoctorById:
//            return SubscriptionEndPoints.GetDoctorById.rawValue
//        case .GetCustomerUpComingSession:
//            return SubscriptionEndPoints.GetCustomerUpComingSession.rawValue
        case .GetCustomerPackageSessionList:
            return SubscriptionEndPoints.GetCustomerPackageSessionList.rawValue
        case .FileType:
            return SubscriptionEndPoints.FileType.rawValue
        case .GetCustomerPackageInstructionByCPId:
            return SubscriptionEndPoints.GetCustomerPackageInstructionByCPId.rawValue
//        case .CreateDoctorMessage:
//            return SubscriptionEndPoints.CreateDoctorMessage.rawValue
//        case .CreateCustomerMessage:
//            return SubscriptionEndPoints.CreateCustomerMessage.rawValue
//        case .GetMessage:
//            return SubscriptionEndPoints.GetMessage.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetCustomerPackageList,
                .GetCustomerPackageSessionList
            :
            return .post
            
        case
                .FileType,
                .GetCustomerPackageInstructionByCPId
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .GetCustomerPackageList(parameters: let parameter),
                .GetCustomerPackageSessionList(parameters: let parameter),
                .GetCustomerPackageInstructionByCPId(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .FileType
            :
            return nil
        }
    }
    
}
