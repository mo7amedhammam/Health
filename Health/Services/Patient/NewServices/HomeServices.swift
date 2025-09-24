//
//  HomeServices.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/05/2025.
//

import Alamofire


enum HomeServices{
    case GetUpcomingSession
    case GetAllHomeCategory(parameters : [String:Any])
    case GetMyMeasurementsStats
    case FeaturedPackageList(parameters : [String:Any])
    case MostBookedPackage(parameters : [String:Any])
    case MostViewedPackage(parameters : [String:Any])

    //MARK: -- Details --
    
    case GetMainCategoryById(parameters : [String:Any]) //get
    case GetSubCategoryByParentId(parameters : [String:Any]) //post
    case GetPackageByCategoryId(parameters : [String:Any]) //post

    case AddOrRemoveToWishList(parameters : [String:Any]) //get
    case GetWishList //get

//    case GetBydIdPb(parameters : [String:Any])
    case GetAvailableShiftDoctors(parameters : [String:Any])
    case GetDoctorPackageById(parameters : [String:Any])
    case GetDoctorAvailableDayList(parameters : [String:Any])
    case GetTimeShiftScheduleList(parameters : [String:Any])
    case GetAvailableDoctorSchedule(parameters : [String:Any])
    case GetBookingSession(parameters : [String:Any])
    case CreateCustomerPackage(parameters : [String:Any])
    case rescheduleSession(parameters : [String:Any])

    case CustomerSessionCalender(parameters : [String:Any])
}

extension HomeServices : TargetType1 {
    var timeoutInterval: TimeInterval? {
        return nil
    }
    var path: String {
        switch self {
        case .GetUpcomingSession:
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
                return newEndPoints.GetCustomerUpcomingSession.rawValue

            case .Doctor:
                return DocEndPoints.DocGetDoctorUpComingSession.rawValue
            }
    
        case .GetAllHomeCategory:
            return newEndPoints.GetAllHomeCategory.rawValue
            
        case .GetMyMeasurementsStats:
            return newEndPoints.GetMyMeasurementsStats.rawValue
            
            case .FeaturedPackageList:
            return newEndPoints.FeaturedPackageList.rawValue
            
        case .MostBookedPackage:
            return newEndPoints.MostBookedPackage.rawValue
            
        case .MostViewedPackage:
            return newEndPoints.MostViewedPackage.rawValue
            
        case .GetMainCategoryById:
            return newEndPoints.GetMainCategoryById.rawValue
            
        case .GetSubCategoryByParentId:
            return newEndPoints.GetSubCategoryByParentId.rawValue
            
        case .GetPackageByCategoryId:
            return newEndPoints.GetPackageByCategoryId.rawValue
            
        case .AddOrRemoveToWishList:
            return newEndPoints.AddOrRemoveToWishList.rawValue
        case .GetWishList:
            return newEndPoints.GetWishList.rawValue
            
        case .GetAvailableShiftDoctors:
            return newEndPoints.GetAvailableShiftDoctors.rawValue
        case .GetDoctorPackageById:
            return newEndPoints.GetDoctorPackageById.rawValue

        case .GetDoctorAvailableDayList:
            return newEndPoints.GetDoctorAvailableDayList.rawValue
        case .GetTimeShiftScheduleList:
            return newEndPoints.GetTimeShiftScheduleList.rawValue
        case .GetAvailableDoctorSchedule:
            return newEndPoints.GetAvailableDoctorSchedule.rawValue
        case .GetBookingSession:
            return newEndPoints.GetBookingSession.rawValue
        case .CreateCustomerPackage:
            return newEndPoints.CreateCustomerPackage.rawValue
        case .rescheduleSession:
            return newEndPoints.ReschedualSession.rawValue
            
        case .CustomerSessionCalender:
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
                return AppointmentEndPoints.CustomerSessionCalender.rawValue

            case .Doctor:
                return DocEndPoints.DocDoctorSessionCalender.rawValue
            }
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case
                .GetAllHomeCategory,
                .FeaturedPackageList,
                .GetSubCategoryByParentId,
                .GetPackageByCategoryId,
                .GetAvailableShiftDoctors,
                .GetDoctorAvailableDayList,
                .GetAvailableDoctorSchedule,
                .GetBookingSession,
                .CreateCustomerPackage,
                .CustomerSessionCalender,
                .rescheduleSession
            :
            return .post
            
        case
                .GetUpcomingSession,
                .GetMyMeasurementsStats,
                .MostBookedPackage,
                .MostViewedPackage,
                .GetMainCategoryById,
                .AddOrRemoveToWishList,
                .GetWishList,
                .GetDoctorPackageById,
                .GetTimeShiftScheduleList
            :
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case
            .GetAllHomeCategory(parameters: let parameter),
            .FeaturedPackageList(parameters: let parameter),
            .MostBookedPackage(parameters: let parameter),
            .MostViewedPackage(parameters: let parameter),
            .GetSubCategoryByParentId(parameters: let parameter),
            .GetPackageByCategoryId(parameters: let parameter),
            .GetMainCategoryById(parameters: let parameter),
            .AddOrRemoveToWishList(parameters: let parameter),
            .GetAvailableShiftDoctors(parameters: let parameter),
            .GetDoctorPackageById(parameters: let parameter),
            .GetDoctorAvailableDayList(parameters: let parameter),
            .GetAvailableDoctorSchedule(parameters: let parameter),
            .GetBookingSession(parameters: let parameter),
            .CreateCustomerPackage(parameters: let parameter),
            .CustomerSessionCalender(parameters: let parameter),
            .rescheduleSession(parameters: let parameter)
            :
//            return .parameterRequest(Parameters: parameters, Encoding: encoding)
            return  parameter

//        case .GetMyScheduleDrugs(parameters: let parameters):
//            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
            
        case
//                .GetDistricts,
//                .GetGenders,
                .GetUpcomingSession,
                .GetMyMeasurementsStats,
                .GetTimeShiftScheduleList,
                .GetWishList
            :
            return nil
        }
    }
    
}
