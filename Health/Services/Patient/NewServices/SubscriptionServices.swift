//
//  SubscriptionServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/05/2025.
//

import Foundation


//import Alamofire


enum SubscriptionServices{
    case GetCustomerPackageList(parameters : [String:Any])
    case GetCustomerPackageById(parameters : [String:Any])
//    case GetDoctorById(parameters : [String:Any])
//    case GetCustomerUpComingSession
    case GetCustomerPackageSessionList(parameters : [String:Any])
    case FileType
    case GetCustomerPackageInstructionByCPId(parameters : [String:Any])
//    case CreateDoctorMessage(parameters : [String:Any])
    case CreateCustomerMessage(parameters : [MultipartFormDataPart])
    case GetMessage(parameters : [String:Any])
    
    case CancelSubscription(parameters : [String:Any])

}

extension SubscriptionServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .GetCustomerPackageList:
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
                return SubscriptionEndPoints.GetCustomerPackageList.rawValue

                case .Doctor:
                return DocEndPoints.DocGetDoctorCustomerPackageList.rawValue
            }
            
        case .GetCustomerPackageById:
            return SubscriptionEndPoints.GetCustomerPackageById.rawValue
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
            
        case .CreateCustomerMessage:
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:

            return SubscriptionEndPoints.CreateCustomerMessage.rawValue
        case .Doctor:
            return DocEndPoints.DocCreateDoctorMessage.rawValue

        }

        case .GetMessage:
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
                return SubscriptionEndPoints.GetMessage.rawValue

            case .Doctor:
                return DocEndPoints.DocGetMessage.rawValue

            }
            
        case .CancelSubscription:
            return SubscriptionEndPoints.CustomerPackageCancel.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetCustomerPackageList,
                .GetCustomerPackageSessionList,
//                .CreateDoctorMessage,
                .CreateCustomerMessage,
                .CancelSubscription
            :
            return .post
            
        case
                .FileType,
                .GetCustomerPackageById,
                .GetMessage,
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
                .GetCustomerPackageById(parameters: let parameter),
                .GetCustomerPackageInstructionByCPId(parameters: let parameter),
//                .CreateDoctorMessage(parameters: let parameter),
                .GetMessage(parameters: let parameter),
                .CancelSubscription(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .FileType
                ,.CreateCustomerMessage
            :
            return nil
        }
    }
    
    
}
