//
//  HomeServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Alamofire


enum HomeServices{
    case GetUpcomingSession
    case GetAllHomeCategory(parameters : [String:Any])
    case GetMyMeasurementsStats
    case FeaturedPackageList(parameters : [String:Any])
    case MostBookedPackage(parameters : [String:Any])
    case MostViewedPackage(parameters : [String:Any])

    //MARK: -- Details --
    
    case GetMainCategoryById(parameters : [String:Any]) //get
    case GetSubCategoryByParentId(parameters : [String:Any]) //post
    case GetPackageByCategoryId(parameters : [String:Any]) //post

    case AddOrRemoveToWishList(parameters : [String:Any]) //get
}

extension HomeServices : TargetType1 {
    var path: String {
        switch self {
        case .GetUpcomingSession:
            return newEndPoints.GetCustomerUpcomingSession.rawValue
    
        case .GetAllHomeCategory:
            return newEndPoints.GetAllHomeCategory.rawValue
            
        case .GetMyMeasurementsStats:
            return newEndPoints.GetMyMeasurementsStats.rawValue
            
            case .FeaturedPackageList:
            return newEndPoints.FeaturedPackageList.rawValue
            
        case .MostBookedPackage:
            return newEndPoints.MostBookedPackage.rawValue
            
        case .MostViewedPackage:
            return newEndPoints.MostViewedPackage.rawValue
            
        case .GetMainCategoryById:
            return newEndPoints.GetMainCategoryById.rawValue
            
        case .GetSubCategoryByParentId:
            return newEndPoints.GetSubCategoryByParentId.rawValue
            
        case .GetPackageByCategoryId:
            return newEndPoints.GetPackageByCategoryId.rawValue
            
        case .AddOrRemoveToWishList:
            return newEndPoints.AddOrRemoveToWishList.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetAllHomeCategory,
                .FeaturedPackageList,
                .GetSubCategoryByParentId,.GetPackageByCategoryId:
            return .post
            
        case
                .GetUpcomingSession,
                .GetMyMeasurementsStats,
                .MostBookedPackage,.MostViewedPackage,
                .GetMainCategoryById,.AddOrRemoveToWishList:
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
            .GetAllHomeCategory(parameters: let parameter),
            .FeaturedPackageList(parameters: let parameter),
            .MostBookedPackage(parameters: let parameter), .MostViewedPackage(parameters: let parameter),
            .GetSubCategoryByParentId(parameters: let parameter),.GetPackageByCategoryId(parameters: let parameter),
            .GetMainCategoryById(parameters: let parameter),.AddOrRemoveToWishList(parameters: let parameter):
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
//                .GetDistricts,
//                .GetGenders,
                .GetUpcomingSession,
                .GetMyMeasurementsStats:
            return nil
        }
    }
    
}
