
//
//  DocActivePackagesServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/09/2025.
//

import Alamofire

enum DocActivePackagesServices{
    case GetCustomerPackageList(parameters : [String:Any])
    case GetCustomerPackageById(parameters : [String:Any])
    case GetCustomerMeasurements(parameters : [String:Any])
    
    //    case GetDoctorById(parameters : [String:Any])
    //    case GetCustomerUpComingSession
    case GetCustomerPackageSessionList(parameters : [String:Any])
    case FileType
    case GetCustomerPackageInstructionByCPId(parameters : [String:Any])
    //    case CreateDoctorMessage(parameters : [String:Any])
    //    case CreateCustomerMessage(parameters : [MultipartFormDataPart])
    //    case GetMessage(parameters : [String:Any])
    
    case CancelSubscription(parameters : [String:Any])
    
    case GetCustomerPackageQuest(parameters : [String:Any])
    case CreatePackageQuestionnaireAnswer(parameters : [String:Any])
    case GetCustomerAllergy(parameters : [String:Any])
}

extension DocActivePackagesServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .GetCustomerPackageList:
            return DocEndPoints.DocGetActivePackageDoctorList.rawValue
            
        case .GetCustomerPackageById:
            return SubscriptionEndPoints.GetCustomerPackageById.rawValue
            //        case .GetDoctorById:
            //            return SubscriptionEndPoints.GetDoctorById.rawValue
            //        case .GetCustomerUpComingSession:
            //            return SubscriptionEndPoints.GetCustomerUpComingSession.rawValue
            
        case .GetCustomerMeasurements:
            return DocEndPoints.DocGetPatientMeasurements.rawValue
            
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
            
        case .CancelSubscription:
            return SubscriptionEndPoints.CustomerPackageCancel.rawValue
            
        case .GetCustomerPackageQuest:
            return DocEndPoints.DocGetCustomerPackageQuest.rawValue
            
        case .CreatePackageQuestionnaireAnswer:
            return DocEndPoints.DocCreateDoctorPackageRequest.rawValue
            
        case .GetCustomerAllergy:
            return DocEndPoints.DocGetCustomerAllergy.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetCustomerPackageList,
                .GetCustomerPackageSessionList,
            //                .CreateDoctorMessage,
            //                .CreateCustomerMessage,
                .CancelSubscription,
                .GetCustomerMeasurements,
                .CreatePackageQuestionnaireAnswer
            :
            return .post
            
        case
                .FileType
            ,.GetCustomerPackageById
            ,.GetCustomerPackageInstructionByCPId,
                .GetCustomerPackageQuest,
                .GetCustomerAllergy
            //               , .GetMessage
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
            //                .GetMessage(parameters: let parameter),
                .CancelSubscription(parameters: let parameter),
                .GetCustomerMeasurements(parameters: let parameter),
                .GetCustomerPackageQuest(parameters: let parameter),
                .CreatePackageQuestionnaireAnswer(parameters: let parameter),
                .GetCustomerAllergy(parameters: let parameter)
            :
            //            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter
            
            //        case .GetMyScheduleDrugs(parameters: let parameters):
            //            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .FileType
            //                ,.CreateCustomerMessage
            :
            return nil
        }
    }
    
}
