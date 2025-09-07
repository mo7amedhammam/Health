//
//  BaseEndPoints.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//

import Foundation

enum apiType:String{
    case testing = "https://alnada-devsehatyapi.azurewebsites.net/"
//    case testing = "https://alnada-sehatyapi.azurewebsites.net/"
    
    case production = "https://api.sehatyapi.app/"
}
struct Constants {
// MARK: - APIs Constants
    
    static var apiType : apiType = .testing
//     var testBaseURL:String {return "https://alnada-devmrsapi.azurewebsites.net/"} //TEST
//     var liveBaseURL:String {return "https://api.mrscool.app/"} //LIVE
    
//    static var liveBaseURL:String {return "https://myhealthapi.azurewebsites.net/"} //LIVE

    static var baseURL:String = apiType.rawValue
    static var apiURL:String {return "\(baseURL)api/\(Helper.shared.getLanguage())/"}
//    static var imagesURL:String {return "https://alnada-sehatyapi.azurewebsites.net/"}
    static var imagesURL:String {return baseURL}


//var TermsAndConditionsURL =  "https://camelgate.app/terms.html"

    static var WhatsAppNum = "+201011138900"
}
