//
//  AvailableDoctorsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/05/2025.
//


import Foundation

@MainActor
final class AvailableDoctorsViewModel:ObservableObject {
    // Input (immutable)
    let package: FeaturedPackageItemM
    
    // Dependencies
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask:Task<Void,Never>? = nil
    
    // Pagination (if needed)
    var maxResultCount: Int = 5
    var skipCount: Int = 0
    
    // Outputs
    @Published var availableDoctors: AvailabeDoctorsM?
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil
    @Published var canLoadMore: Bool? = true

    // Navigation state
    @Published var selectedDoctorPackageId: Int? = nil
    
    // Load-once guard
    private var didLoad = false
    
    init(
        package: FeaturedPackageItemM,
        networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared
    ) {
        self.package = package
        self.networkService = networkService
    }
    
//    func loadOnce() async {
//        guard !didLoad else { return }
//        didLoad = true
//        await getAvailableDoctors()
//    }
    
    func getAvailableDoctors() async {
        guard let appCountryPackageId = package.appCountryPackageId else { return }
        guard canLoadMore == true else { return }
        isLoading = true
        defer { isLoading = false }
        
//        guard let maxResultCount, let skipCount else {
//            self.errorMessage = "check inputs"
//            return
//        }
        
        let parameters: [String: Any] = [
            "appCountryPackageId": appCountryPackageId,
            "maxResultCount": maxResultCount,
            "skipCount": skipCount
        ]
        
        let target = HomeServices.GetAvailableShiftDoctors(parameters: parameters)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(
                target,
                responseType: AvailabeDoctorsM.self
            )
            if skipCount == 0 {
                availableDoctors = response
            } else {
                if var existing = self.availableDoctors,
                   let newItems = response?.items {
                    existing.items?.append(contentsOf: newItems)
                    existing.totalCount = response?.totalCount
                    availableDoctors = existing
                }
            }
            canLoadMore = (response?.items?.count ?? 0) < (response?.totalCount ?? 0)

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func selectDoctor(_ item: AvailabeDoctorsItemM) {
        guard let id = item.packageDoctorID else { return }
        selectedDoctorPackageId = id
    }
    
    func clearSelection() {
        selectedDoctorPackageId = nil
    }
    func loadMoreDoctorsIfNeeded() async {
        guard (canLoadMore ?? false && isLoading == false),
              let currentCount = availableDoctors?.items?.count,
              let totalCount = availableDoctors?.totalCount,
              currentCount < totalCount else { return }

        skipCount = skipCount + maxResultCount
        await self.getAvailableDoctors()
    }
    func refresh() async{
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            skipCount = 0
            await self.getAvailableDoctors()
        }
        await loadTask?.value
    }
}

//MARK: -- Functions --
//extension AvailableDoctorsViewModel{
//    
//    @MainActor
//    func getAvailableDoctors(appCountryPackageId:Int) async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["appCountryPackageId":appCountryPackageId,"maxResultCount" : maxResultCount ,"skipCount" : skipCount]
//        
//        let target = HomeServices.GetAvailableShiftDoctors(parameters: parametersarr)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: AvailabeDoctorsM.self
//            )
//            self.availableDoctors = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//
////    @MainActor
////    func getPackages(categoryId:Int) async {
////        isLoading = true
////        defer { isLoading = false }
////        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
////        }
////        let parametersarr : [String : Any] =  ["categoryId":categoryId,"maxResultCount" : maxResultCount ,"skipCount" : skipCount]
////
////        let target = HomeServices.GetPackageByCategoryId(parameters: parametersarr)
////        do {
////            self.errorMessage = nil // Clear previous errors
////            let response = try await networkService.request(
////                target,
////                responseType: FeaturedPackagesM.self
////            )
////            self.packages = response
////        } catch {
////            self.errorMessage = error.localizedDescription
////        }
////    }
//    
//    
//}
