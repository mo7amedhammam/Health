//
//  EndPoints.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//

import Foundation


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

enum newEndPoints : String{
    
    //    MARK: -- Home
    case GetCustomerUpcomingSession =  "Home/GetCustomerUpcomingSession"
    case GetAllHomeCategory = "Home/GetAllHomeCategory"
    case GetMyMeasurementsStats = "Home/GetMyMeasurementsStats"
    case FeaturedPackageList = "Home/FeaturedPackageList"
    case MostBookedPackage = "Home/MostBookedPackage"
    case MostViewedPackage = "Home/MostViewedPackage"
    
    //   MARK: -- Explore Package
    case GetMainCategoryById = "Home/GetMainCategoryById"
    case GetSubCategoryByParentId = "Home/GetSubCategoryByParentId"
    case GetPackageByCategoryId = "Home/GetPackageByCategoryId"
    
    case AddOrRemoveToWishList = "Home/AddOrRemoveToWishList"
    case GetWishList = "Home/GetWishList"

    //    --------
    case GetBydIdPb                    = "Package/GetBydIdPb"
    case GetAvailableShiftDoctors      = "CustomerPackage/GetAvailableShiftDoctors"
    case GetDoctorPackageById          = "CustomerPackage/GetDoctorPackageById"
    case GetDoctorAvailableDayList     = "CustomerPackage/GetDoctorAvailableDayList"
    case GetTimeShiftScheduleList      = "TimeShiftSchedule/GetTimeShiftScheduleList"
    case GetAvailableDoctorSchedule    = "CustomerPackage/GetAvailableDoctorSchedule"
    case GetBookingSession             = "CustomerPackage/GetBookingSession"
    case CreateCustomerPackage         = "CustomerPackage/CreateCustomerPackage"
    case ReschedualSession             = "CustomerPackage/RescheduleCustomerPackageSession"
    
}


enum SubscriptionEndPoints : String{
//--------  Subscription -------
case GetCustomerPackageList              = "Subscription/GetCustomerPackageList"
case GetCustomerPackageById              = "CustomerPackage/GetCustomerPackageById"
case GetDoctorById                       = "Doctor/GetDoctorById"
case GetCustomerUpComingSession          = "Home/GetCustomerUpComingSession"
case GetCustomerPackageSessionList       = "Subscription/GetCustomerPackageSessionList"
//case GetCustomerPackageInstructionByCPId = "Subscription/GetCustomerPackageInstructionByCPId"
//case CreateDoctorMessage                 = "CustomerPackageMessage/CreateDoctorMessage"
case CreateCustomerMessage               = "CustomerPackageMessage/CreateCustomerMessage"
case GetMessage                          = "CustomerPackageMessage/GetMessage"
case CustomerPackageCancel               = "CustomerPackage/CustomerPackageCancel"
    
    case FileType                            = "Lookups/FileType"
    case GetCustomerPackageInstructionByCPId = "CustomerPackageInstructions/GetCustomerPackageInstructionByCPID"
    case CreateCustomerPackageInstructionByCPId = "CustomerPackageInstructions/CreateCustomerPackageInstruction"

//    case GetCustomerPackageInstructionByCPId = "CustomerPackageInstructions/GetCustomerPackageInstructionByCPID"
//    case CreateCustomerPackageInstructionByCPId = "CustomerPackageInstructions/CreateCustomerPackageInstruction"

}

enum AppointmentEndPoints : String{
   case CustomerSessionCalender = "CustomerPackageSession/CustomerSessionCalender"
}


enum LookupsEndPoints : String{
   case GetAppCountryForList = "AppCountry/GetAppCountryForList"
    case GetAllGenders = "Lookups/GetAllGenders"
    case GetAllLanguages = "Lang/GetLangList"
    case GetAllFileTypes = "Lookups/FileType"
    case GetSpecialityForList = "Speciality/GetSpecialityForList"
}


enum MyFilesEndPoints : String{
    case AddFile = "CustomerFile/AddFile"
    case UpdateFile = "CustomerFile/UpdateFile"
    case GetCustomerFileList = "CustomerFile/GetCustomerFileList"
    case GetCustomerFile = "CustomerFile/GetCustomerFile"
}

enum MyAllergiesEndPoints : String{
    case AddCustomerAllergy = "Allergy/AddCustomerAllergy"
    case GetCustomerAllergies = "Allergy/GetAllergyWithCategory"
}


enum MyWalletEndPoints : String{
  case CustomerWalletBalance = "Customer/CustomerWalletBalance"
  case CustomerOrderDetail = "CustomerPackage/CustomerOrderDetail"
  case RefundDetail = "CustomerPackage/RefundDetail"
}

enum ProfileEndPoints : String{
    case GetProfile = "Customer/MyProfile"
    case UpdateProfile = "Customer/Update"
}


