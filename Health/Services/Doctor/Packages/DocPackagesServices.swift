//
//  DocPackagesServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 14/09/2025.
//

import Alamofire

enum DocPackagesServices{
    case GetPackageDoctor(parameters : [String:Any])
    case GetMainCategoryDBForList
    case GetSubCategoryForList(parameters : [String:Any])
    case GetPackageForList(parameters : [String:Any])
    case CreateDoctorPackageRequest(parameters : [String:Any])
}

extension DocPackagesServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
        case .GetPackageDoctor:
            return DocEndPoints.DocGetPackageDoctorList.rawValue
            
        case .GetMainCategoryDBForList:
            return DocEndPoints.DocGetMainCategoryDBForList.rawValue
            
        case .GetSubCategoryForList:
            return DocEndPoints.DocGetSubCategoryForList.rawValue
            
        case .GetPackageForList:
            return DocEndPoints.DocPackageForList.rawValue
            
        case .CreateDoctorPackageRequest:
            return DocEndPoints.DocCreateDoctorPackageRequest.rawValue
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetPackageDoctor
            ,.CreateDoctorPackageRequest
            :
            return .post
            
        case
                .GetMainCategoryDBForList
            ,.GetSubCategoryForList
            ,.GetPackageForList
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .GetPackageDoctor(parameters: let parameter)
            ,.GetPackageForList(parameters: let parameter)
            ,.GetSubCategoryForList(parameters: let parameter)
            ,.CreateDoctorPackageRequest(parameters: let parameter)
            :
            ////            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter
            
            //        case .GetMyScheduleDrugs(parameters: let parameters):
            //            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .GetMainCategoryDBForList
            :
            return nil
        }
    }
    
    
}
