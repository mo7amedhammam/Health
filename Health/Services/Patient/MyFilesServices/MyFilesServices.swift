//
//  MyFilesServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//

import Foundation

//import Alamofire
enum MyFilesServices{
    case AddFile(parameters : [String:Any])
    case UpdateFile(parameters : [String:Any])
    case GetFiles(parameters : [String:Any])


}

extension MyFilesServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    
    var path: String {
        switch self {
            
        case .AddFile:
            return MyFilesEndPoints.AddFile.rawValue

        case .UpdateFile:
            return MyFilesEndPoints.UpdateFile.rawValue

        case .GetFiles:
            return MyFilesEndPoints.GetCustomerFileList.rawValue

        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .AddFile,
                .UpdateFile
            :
            return .post
            
        case
                .GetFiles
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
                .AddFile(parameters: let parameter),
                .UpdateFile(parameters: let parameter),
                .GetFiles(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
//        case
//                .GetFiles
//            :
//            return nil
        }
    }
    
    
}
