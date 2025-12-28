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

extension AvailabeDoctorsItemM {
    
    static let mockList: [AvailabeDoctorsItemM] = [
        AvailabeDoctorsItemM(
            packageDoctorID: 101,
            doctorID: 1,
            doctorImage: "https://randomuser.me/api/portraits/men/32.jpg",
            doctorName: "Dr. Ahmed Hassan",
            speciality: "Cardiology"
        ),
        AvailabeDoctorsItemM(
            packageDoctorID: 102,
            doctorID: 2,
            doctorImage: "https://randomuser.me/api/portraits/women/44.jpg",
            doctorName: "Dr. Sara Mohamed",
            speciality: "Dermatology"
        ),
        AvailabeDoctorsItemM(
            packageDoctorID: 103,
            doctorID: 3,
            doctorImage: "https://randomuser.me/api/portraits/men/76.jpg",
            doctorName: "Dr. Omar Ali",
            speciality: "Orthopedics"
        ),
        AvailabeDoctorsItemM(
            packageDoctorID: 104,
            doctorID: 4,
            doctorImage: "https://randomuser.me/api/portraits/women/65.jpg",
            doctorName: "Dr. Nour Khaled",
            speciality: "Pediatrics"
        ),
        AvailabeDoctorsItemM(
            packageDoctorID: 105,
            doctorID: 5,
            doctorImage: "https://randomuser.me/api/portraits/men/11.jpg",
            doctorName: "Dr. Youssef Mahmoud",
            speciality: "Neurology"
        )
    ]
}
