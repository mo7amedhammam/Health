//
//  AvailabeDoctorsM.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/05/2025.
//

// MARK: - AvailabeDoctorsM
struct AvailabeDoctorsM: Codable,Hashable {
    var totalCount: Int?
    var items: [AvailabeDoctorsItemM]?
}

// MARK: - AvailabeDoctorsItemM
struct AvailabeDoctorsItemM: Codable,Hashable {
    var packageDoctorID, doctorID: Int?
    var doctorImage: String?
    var doctorName, speciality: String?

    enum CodingKeys: String, CodingKey {
        case packageDoctorID = "packageDoctorId"
        case doctorID = "doctorId"
        case doctorImage, doctorName, speciality
    }
}
