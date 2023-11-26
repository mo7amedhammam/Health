//
//  File.swift
//  Memoria
//
//  Created by mac on 05/04/2021.
//

import Foundation

final class Shared {
    
    static let shared = Shared()
    
    var lang : String!
    var logedin = 0
    
    var ScreenNoInternet = 0
    var PackageIsSuccessfullAdded = 0
    
//    var NameAr  = ""
//    var NameEn  = ""
    
    var IndexServiceIdtoremoveReason = 0
    var FromAppDelegate = 0
    var MustUpdate = false
    
    var ServiceRequest = ""
    var payment = ""
    var Multipart = ""
    var Multipart2 = ""
    
    var MeasurementId = 0
    var IsMeasurementAdded = false
    var ValueMeasurementAdded = ""
}
