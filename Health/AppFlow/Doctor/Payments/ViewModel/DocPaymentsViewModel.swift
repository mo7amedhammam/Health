//
//  DocPaymentsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/09/2025.
//

import Foundation

class DocPaymentsViewModel : ObservableObject {
    static let shared = DocPaymentsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
        
    // Published properties
    @Published var ballance : DocBallanceM?
    @Published var previousSubsriptions : [DocOrderDetailM]?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension DocPaymentsViewModel{
        
    @MainActor
    func getMyBallance() async {
//        isLoading = true
//        defer { isLoading = false }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = DocPaymentsServices.DocWalletBalance
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: DocBallanceM.self
            )
            self.ballance = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getPreviousSubsriptions() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = DocPaymentsServices.DocOrderDetail
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [DocOrderDetailM].self
            )
            self.previousSubsriptions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    func getdata() async{
        isLoading = true
        defer { isLoading = false }

        async let ballance: () = getMyBallance()
        async let previousSubsriptions: () = getPreviousSubsriptions()
        await _ = (ballance,previousSubsriptions)
    }
}


