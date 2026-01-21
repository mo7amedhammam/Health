//
//  DocPaymentsServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//

import Foundation

//import Alamofirex

enum DocPaymentsServices{
    case DocWalletBalance
    case DocOrderDetail
//    case DocRefundDetail
}

extension DocPaymentsServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .DocWalletBalance:
            return DocEndPoints.DocGetDoctorFinance.rawValue

        case .DocOrderDetail:
            return DocEndPoints.DocGetDoctorFinanceDetail.rawValue

//        case .DocRefundDetail:
//            return MyWalletEndPoints.RefundDetail.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
//        case
//                .AddAllergies
//            :
//            return .post
            
        case
                .DocWalletBalance
            ,.DocOrderDetail
//            ,.DocRefundDetail
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
                .DocWalletBalance
            ,.DocOrderDetail
//            ,.DocRefundDetail
            :
            return nil
        }
    }
    
    
}
