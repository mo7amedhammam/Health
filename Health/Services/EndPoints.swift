//
//  EndPoints.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
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
    static var imagesURL:String {return "https://alnada-sehatyapi.azurewebsites.net/"}

//var TermsAndConditionsURL =  "https://camelgate.app/terms.html"

    static var WhatsAppNum = "+201011138900"
}

enum EndPoints: String {
    // MARK: - Auth
    case Register = "Customer/Create"
    case VerifyUser = "Customer/VerifyUser"
    case Login = "Customer/Login"

    case sendOTP = "Customer/SendOTP"
    case VerifyOTP = "Customer/VerifyOTP"

    case ResetPassword = "Customer/ResetPassword"
    case ChangePassword = "Customer/ChangePassword"

    //MARK: -- Lookups --
    case GetAllGenders = "Lookups/GetAllGenders"
    case GetAllDistricts = "District/GetAllForList"
    
    //MARK: -- Main tab --
    case HomePageNewest = "Questions/HomePageNewest"
 
    case MyMeasurementsStats    = "CustomerMedicalMeasurement/GetMyMeasurementsStats"
    case MeasurementNormalRange = "MedicalMeasurement/GetNormalRange"
    case MyMedicalMeasurements  = "CustomerMedicalMeasurement/GetMyMedicalMeasurements"
    case CreateMeasurement      = "CustomerMedicalMeasurement/Create"

    //  -- MedicineSchedual --
    case GetMySchedulePrescriptions = "CustomerPrescription/GetMySchedulePrescriptions"
    case GetMyScheduleDrugs = "CustomerPrescriptionDrug/GetMyScheduleDrugs"
    
    // -- inbody --
     case GetCustomerInBody = "CustomerInBodyTest/GetMyList"
    case CreateCustomerInBody = "CustomerInBodyTest/Create"
    
    // -- notifications --
//    case GetNotification = "CustomerPrescriptionDrug/GetCustomerNormalDrugs"
        case GetNotification = "CustomerPrescriptionDrug/GetMyNormalDrugs"

    // -- pfofile --
    case GetMyProfile = "Customer/MyProfile"

    // -- tips categories --
    case GetAllMobile = "TipCategory/GetAllMobile"
    case GetTipNewest = "Tip/GetTipNewest"
    case GetTipInterestYou = "Tip/GetTipInterestYou"
    case GetTipMostViewed = "Tip/GetTipMostViewed"
    case GetByCategory = "Tip/GetByCategory"
    case GetDetail = "Tip/GetDetail"
    case CreateNotification = "CustomerPrescriptionDrug/Create"
    case GetDrug = "Drug/Get"
    
    //--Home--
    case GetAlmostFinishedPresc = "CustomerPrescription/GetCustomerAlmostFinishedPrescription"
    case getHelp = "Help/Get"
    case SendFireBaseDeviceToken = "Customer/UpdateFirebaseDeviceToken"
    
    ///api/Customer/UpdateFirebaseDeviceToken
}
