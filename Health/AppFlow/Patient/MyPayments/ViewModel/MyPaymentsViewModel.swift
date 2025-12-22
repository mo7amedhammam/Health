//
//  MyPaymentsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/06/2025.
//

import Foundation


class MyPaymentsViewModel : ObservableObject {
    static let shared = MyPaymentsViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil
        
    // Published properties
    @Published var ballance : CustomerBallanceM?
    @Published var previousSubsriptions : [CustomerOrderDetailM]?
    @Published var refundedSubsriptions : [CustomerOrderDetailM]?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension MyPaymentsViewModel{
    
//    @MainActor
//    func addNewAllergies() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let allergies = addAllergies else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        var parametersarr : [String : Any] = [ : ] // handle allergies dictionary
//
//        let target = MyAllergiesServices.AddAllergies(parameters: parametersarr)
//
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: AllergiesM.self
//            )
////            self.allergies = response
//            //update or get allergies to update
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    
//    @MainActor
//    func addNewAllergies(selectedIds: Set<Int>, langId: Int = 1) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        guard let allergies = self.allergies else { return }
//
//        let payloadArray: [[String: Any]] = allergies.compactMap { category in
//            guard let categoryId = category.allergyCategoryID else { return nil }
//
//            let matchedAllergies = (category.allergyList ?? []).filter { allergy in
//                selectedIds.contains(allergy.id ?? -1)
//            }
//
//            guard !matchedAllergies.isEmpty else { return nil }
//
//            let nameList: [[String: Any]] = matchedAllergies.compactMap { allergy in
//                guard let name = allergy.name else { return nil }
//                return [
//                    "langId": langId,
//                    "fieldName": name,
//                    "fieldText": name
//                ]
//            }
//
//            return [
//                "allergyCategoryId": categoryId,
//                "nameList": nameList
//            ]
//        }
//
//        let parameters: [String: Any] = ["allergies": payloadArray]
//
//        let target = MyAllergiesServices.AddAllergies(parameters: parameters)
//
//        do {
//            self.errorMessage = nil
//            _ = try await networkService.request(target, responseType: AllergiesM.self)
//            await getMyAllergies()
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    
    
    @MainActor
    func getMyBallance() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyWalletServices.CustomerWalletBalance
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: CustomerBallanceM.self
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
        
        let target = MyWalletServices.CustomerOrderDetail
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [CustomerOrderDetailM].self
            )
            self.previousSubsriptions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getRefundedSubsriptions() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyWalletServices.RefundDetail
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [CustomerOrderDetailM].self
            )
            self.refundedSubsriptions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}

extension MyPaymentsViewModel {

    @MainActor
    func refresh() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            //        skipCount = 0
            async let balance:() = self.getMyBallance()
            async let prevpayments:() = self.getPreviousSubsriptions()
            async let refunded:() = self.getRefundedSubsriptions()
            _ = await (balance,prevpayments,refunded)
        }
        await loadTask?.value
    }

//    @MainActor
//    func loadMoreIfNeeded() async {
//        guard !(isLoading ?? false),
//              let currentCount = appointments?.items?.count,
//              let totalCount = appointments?.totalCount,
//              currentCount < totalCount,
//              let maxResultCount = maxResultCount else { return }
//
//        skipCount = (skipCount ?? 0) + maxResultCount
//        await getAppointmenstList()
//    }
}
