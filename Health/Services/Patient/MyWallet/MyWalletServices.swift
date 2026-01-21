//
//  MyWalletServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/06/2025.
//

import Foundation

//import Alamofire
enum MyWalletServices{
    case CustomerWalletBalance
    case CustomerOrderDetail
    case RefundDetail
}

extension MyWalletServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .CustomerWalletBalance:
            return MyWalletEndPoints.CustomerWalletBalance.rawValue

        case .CustomerOrderDetail:
            return MyWalletEndPoints.CustomerOrderDetail.rawValue

        case .RefundDetail:
            return MyWalletEndPoints.RefundDetail.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
//        case
//                .AddAllergies
//            :
//            return .post
            
        case
                .CustomerWalletBalance
            ,.CustomerOrderDetail
            ,.RefundDetail
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
//        case
//                .AddAllergies(parameters: let parameter)
//            :
////            return .parameterRequest(Parameters: parameters, Encoding: encoding)
//            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
                .CustomerWalletBalance
            ,.CustomerOrderDetail
            ,.RefundDetail
            :
            return nil
        }
    }
    
    
}
