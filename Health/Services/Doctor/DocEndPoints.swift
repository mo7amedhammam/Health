//
//  DocEndPoints.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//


enum DocEndPoints : String{
//MARK: -    —— Doctor Api ——
    // MARK: - Auth
    case DocRegister = "Doctor/Create"
    case DocVerifyUser = "Doctor/VerifyUser"
    case DocLogin = "Doctor/Login"

    case DocsendOTP = "Doctor/SendOTP"
    case DocVerifyOTP = "Doctor/VerifyOTP"

    case DocResetPassword = "Doctor/ResetPassword"
    case DocChangePassword = "Doctor/ChangePassword"
    
    // -- pfofile --
    case DocGetMyProfile = "Doctor/GetById"
    case DocUpdateMyProfile = "Doctor/Update"

    //------------My Schedule----------
    case GetDoctorSchedule = "Doctor/GetDoctorSchedule"
    case CreateDoctorSchedule = "Doctor/CreateDoctorSchedule"
    case DeleteSchedule = "Doctor/DeleteSchedule"
    
//-----------My Appointments--------
    case DocGetDoctorUpComingSession = "Home/GetDoctorUpComingSession"
    case DocDoctorSessionCalender = "CustomerPackageSession/DoctorSessionCalender"
    case DocGetDoctorCustomerPackageList = "CustomerPackageSession/GetDoctorCustomerPackageList"

//-----------Active Customer Packages----------
    case DocGetCustomerPackageSessionList = "Subscription/GetCustomerPackageSessionList"
    case DocGetActivePackageDoctorList = "packageDoctor/GetPackageDoctorList"
    case DocCreateCustomerPackageByDoctor = "CustomerPackage/CreateCustomerPackageByDoctor"
    case DocGetMessage = "CustomerPackageMessage/GetMessage"
    case DocCreateDoctorMessage = "CustomerPackageMessage/CreateDoctorMessage"
    case DocGetCustomerPackageInstructionByCPID = "CustomerPackageInstructions/GetCustomerPackageInstructionByCPID"
    case DocGetPatientMeasurements = "CustomerMedicalMeasurement/GetPatientMeasurements"
    
//-------MyPackages---------
    case DocGetPackageDoctorList = "PackageDoctor/GetPackageDoctorList"
    case DocGetMainCategoryDBForList = "Home/GetMainCategoryDBForList"
    case DocGetSubCategoryForList = "Home/GetSubCategoryForList"
    case DocPackageForList = "Package/PackageForList"
    case DocGetAppCountryByPackageId = "AppCountry/GetAppCountryByPackageId"
    case DocCreateDoctorPackageRequest = "PackageDoctor/CreateDoctorPackageRequest"

//----------Booking ------------
//- [ ] Same As Customers

//-----------Payments-------------
    case DocGetDoctorFinance = "Doctor/GetDoctorFinance"
    case DocGetDoctorFinanceDetail = "Doctor/GetDoctorFinanceDetail"
    
    //-----------Questionaire-------------
    case DocGetCustomerPackageQuest = "Questionnaire/GetCustomerPackageQuest"
    case DocCreatePackageQuestionnaireAnswer = "Questionnaire/CreatePackageQuestionnaireAnswer"

    //-----------CustomerAllergy-------------
    case DocGetCustomerAllergy = "Allergy/GetCustomerAllergy"

}
