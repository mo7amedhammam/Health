//
//  PackageMoreDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/05/2025.
//


import Foundation

class PackageMoreDetailsViewModel:ObservableObject {
    static let shared = PackageMoreDetailsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
    var maxResultCount: Int?              = 5
    var skipCount: Int?                   = 0
    
    var doctor:AvailabeDoctorsItemM                      = .init()
    @Published var selectedDate           = Date()
    
    // Published properties
    @Published var packageDetails: PackageMoreDetailsM?
    @Published var availableDays: [AvailableDayM]?

    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension PackageMoreDetailsViewModel{
    
    @MainActor
    func getDoctorPackageDetails() async {
        isLoading = true
        defer { isLoading = false }
        guard let doctorPackageId = doctor.packageDoctorID else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["Id":doctorPackageId ]
        
        let target = HomeServices.GetDoctorPackageById(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: PackageMoreDetailsM.self
            )
            self.packageDetails = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func getAvailableDays() async {
        isLoading = true
        defer { isLoading = false }
        guard let doctorId = doctor.doctorID  else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["Date":"\(selectedDate.formatted(.customDateFormat("YYYY-MM-dd")))","DoctorId":doctorId]

        let target = HomeServices.GetDoctorAvailableDayList(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AvailableDayM].self
            )
            self.availableDays = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
}
