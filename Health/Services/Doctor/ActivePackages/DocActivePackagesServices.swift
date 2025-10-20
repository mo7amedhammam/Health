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
    
    case GetCustomerPackageSessionList(parameters : [String:Any])
    case FileType
    case GetCustomerPackageInstructionByCPId(parameters : [String:Any])
    
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
            
        case .GetCustomerMeasurements:
            return DocEndPoints.DocGetPatientMeasurements.rawValue
            
        case .GetCustomerPackageSessionList:
            return SubscriptionEndPoints.GetCustomerPackageSessionList.rawValue
        case .FileType:
            return SubscriptionEndPoints.FileType.rawValue
        case .GetCustomerPackageInstructionByCPId:
            return SubscriptionEndPoints.GetCustomerPackageInstructionByCPId.rawValue
            
        case .CancelSubscription:
            return SubscriptionEndPoints.CustomerPackageCancel.rawValue
            
        case .GetCustomerPackageQuest:
            return DocEndPoints.DocGetCustomerPackageQuest.rawValue
            
        case .CreatePackageQuestionnaireAnswer:
            // FIX: point to questionnaire endpoint, not doctor package request
            return DocEndPoints.DocCreatePackageQuestionnaireAnswer.rawValue
            
        case .GetCustomerAllergy:
            return DocEndPoints.DocGetCustomerAllergy.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetCustomerPackageList,
                .GetCustomerPackageSessionList,
                .CancelSubscription,
                .CreatePackageQuestionnaireAnswer
            :
            return .post
            
        case
                .FileType,
                .GetCustomerPackageById,
                .GetCustomerPackageInstructionByCPId,
                .GetCustomerPackageQuest,
                .GetCustomerAllergy,
                .GetCustomerMeasurements
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
                .CancelSubscription(parameters: let parameter),
                .GetCustomerMeasurements(parameters: let parameter),
                .GetCustomerPackageQuest(parameters: let parameter),
                .CreatePackageQuestionnaireAnswer(parameters: let parameter),
                .GetCustomerAllergy(parameters: let parameter)
            :
            return  parameter
            
        case .FileType:
            return nil
        }
    }
}
