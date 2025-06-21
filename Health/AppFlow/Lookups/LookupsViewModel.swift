//
//  LookupsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 20/06/2025.
//

import Foundation

class LookupsViewModel : ObservableObject {
    static let shared = LookupsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // -- Get List --
        
    // Published properties
    @Published var appCountries : [AppCountryM]? = nil
    @Published var genders : [GenderM]? = nil

//    @Published var isLoading:Bool? = false
//    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension LookupsViewModel{
    
//    @MainActor
    func getAppCountries() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = LookUpsServices.GetALlCountries
        do {
            //            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [AppCountryM].self
            )
            Task{
                await MainActor.run{
                    self.appCountries = response
                }
            }
        } catch {
//            self.errorMessage = error.localizedDescription
        }
    }
    
    //    @MainActor
        func getGenders() async {
    //        isLoading = true
    //        defer { isLoading = false }
    //        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
    ////            // Handle missings
    ////            self.errorMessage = "check inputs"
    ////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
    //            return
    //        }
    //        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
            
            let target = LookUpsServices.GetALlGenders
            do {
    //            self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [GenderM].self
                )
                Task{
                    await MainActor.run{
                        self.genders = response
                    }
                }
            } catch {
    //            self.errorMessage = error.localizedDescription
            }
        }
    
}

