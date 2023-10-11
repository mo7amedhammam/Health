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

    static var WhatsAppNum = "+201011138900"
}

enum EndPoints: String {
    // MARK: - Auth
    case Register = "RegisterRequest/Create"
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
    case GetNotification = "CustomerPrescriptionDrug/GetCustomerNormalDrugs"

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
}
