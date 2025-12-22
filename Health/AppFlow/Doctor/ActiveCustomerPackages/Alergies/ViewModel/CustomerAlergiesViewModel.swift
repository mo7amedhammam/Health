//
//  CustomerAlergiesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 26/10/2025.
//

import Foundation

class CustomerAlergiesViewModel : ObservableObject {
    static let shared = CustomerAlergiesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void, Never>? = nil
    
    var CustomerPackageId : Int?

    // Published properties
    @Published var allergies : [CustomerAllergyListM]?
//    @Published var previousSubsriptions : [DocOrderDetailM]?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension CustomerAlergiesViewModel{
        
    @MainActor
    func getCustomerAllergies() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            isLoading = true
            defer { isLoading = false }
            guard let customerPackageId = CustomerPackageId else {
                return
            }
            let parametersarr : [String : Any] =  ["CustomerPackageId":customerPackageId]
            
            let target = DocActivePackagesServices.GetCustomerAllergy(parameters: parametersarr)
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [CustomerAllergyListM].self
                )
                self.allergies = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
    
//    @MainActor
//    func getPreviousSubsriptions() async {
////        isLoading = true
////        defer { isLoading = false }
////        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
//////            // Handle missings
//////            self.errorMessage = "check inputs"
//////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
////        }
////        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
//        
//        let target = DocPaymentsServices.DocOrderDetail
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [DocOrderDetailM].self
//            )
//            self.previousSubsriptions = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    
    
//    func getdata() async{
//        isLoading = true
//        defer { isLoading = false }
//
//        async let ballance: () = getMyBallance()
//        async let previousSubsriptions: () = getPreviousSubsriptions()
//        await _ = (ballance,previousSubsriptions)
//    }
}


