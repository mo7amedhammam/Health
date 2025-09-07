//
//  DocEndPoints.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//


enum DocEndPoints : String{
//MARK: -    —— Doctor Api ——

//------------My Schedule----------
    case DocCreateOrUpdateDoctorSchedule = "Doctor/CreateOrUpdateDoctorSchedule"

//-----------My Appointments--------
    case DocGetDoctorUpComingSession = "Home/GetDoctorUpComingSession"
    case DocDoctorSessionCalender = "CustomerPackageSession/DoctorSessionCalender"
    case DocGetDoctorCustomerPackageList = "CustomerPackageSession/GetDoctorCustomerPackageList"

//-----------Active Customer Packages----------
    case DocGetCustomerPackageSessionList = "Subscription/GetCustomerPackageSessionList"
//    case DocGetPackageDoctorList = "packageDoctor/GetPackageDoctorList"
    case DocCreateCustomerPackageByDoctor = "CustomerPackage/CreateCustomerPackageByDoctor"
    case DocGetMessage = "CustomerPackageMessage/GetMessage"
    case DocCreateDoctorMessage = "CustomerPackageMessage/CreateDoctorMessage"
    case DocGetCustomerPackageInstructionByCPID = "CustomerPackageInstructions/GetCustomerPackageInstructionByCPID"

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
}