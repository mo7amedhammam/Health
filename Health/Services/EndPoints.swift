//
//  EndPoints.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import Foundation

struct Constants {
// MARK: - APIs Constants
    static var baseURL:String {return "https://wecareback.wecancity.com/"} //TEST
//static var baseURL:String {return "https://wecareback.wecancity.com/"} //LIVE

static var apiURL:String {return "\(baseURL)api/"}
//    static var imagesURL:String {return "http://wecareback.wecancity.com/"}

//var TermsAndConditionsURL =  "https://camelgate.app/terms.html"

}

enum EndPoints: String {
    // MARK: - Auth
    case Register = "Customer/Create"
    case Login = "Customer/Login"

    case sendOTP = "Customer/SendOTP"
    case VerifyOTP = "Customer/VerifyOTP"

    case ResetPassword = "Customer/ResetPassword"
    case ChangePassword = "Customer/ChangePassword"

    
    //MARK: -- Main tab --
    case HomePageNewest = "Questions/HomePageNewest"
 

}
