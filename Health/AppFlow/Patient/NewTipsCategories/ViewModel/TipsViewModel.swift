//
//  TipsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/07/2025.
//

import Foundation

class TipsViewModel: ObservableObject {
    static let shared = TipsViewModel()
    
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? =  nil
    
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    @Published var isLoadingMore:Bool? = false

    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
    
    @Published var allTips: TipsAllM?
    @Published var newestTipsArr : [TipsNewestM]?
    @Published var interestingTipsArr : [TipsNewestM]?
    @Published var mostViewedTipsArr : [TipsNewestM]?
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
        Task{ await refresh() }
    }
    
    // MARK: - Fetch Measurement Stats
    @MainActor
    func GetHomeAllTips() async {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            self.errorMessage = "check_inputs".localized
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        print("param",parametersarr)

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.GetAllMobile(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: TipsAllM.self
            )
//            self.allTips = response
            if skipCount == 0 {
                self.allTips = response
            }else{
                allTips?.items?.append(contentsOf: response?.items ?? [])
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    @MainActor
    func GetNewestTips() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.GetTipNewest
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [TipsNewestM].self
            )
            self.newestTipsArr = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func GetInterestingTips() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.GetTipInterestYou
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [TipsNewestM].self
            )
            self.interestingTipsArr = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func GetMostViewedTips() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewTipsServices.GetTipMostViewed
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [TipsNewestM].self
            )
            self.mostViewedTipsArr = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

extension TipsViewModel {
    
    @MainActor
    func refresh() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            skipCount = 0
            isLoading = true
            defer { isLoading = false }
            
            async let allTips: () = GetHomeAllTips()
            async let newestTips: () = GetNewestTips()
            async let interesting: () = GetInterestingTips()
            async let mostViewed: () = GetMostViewedTips()
            
            await _ = ( allTips, newestTips, interesting, mostViewed )
        }
        await loadTask?.value
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard !(isLoadingMore ?? false),
              let currentCount = allTips?.items?.count,
              let totalCount = allTips?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await GetHomeAllTips()
    }
}

//class TipsVM1 {
//    // -- Get List --
//    var maxResultCount: Int? = 10
//    var skipCount: Int? = 0
//    
//    var allTipsResModel: TipsAllM? = TipsAllM()
//    var newestTipsArr : [TipsNewestM]? = []
//    var interestingTipsArr : [TipsNewestM]? = []
//    var mostViewedTipsArr : [TipsNewestM]? = []
//
//}

//MARK: -- Functions --
//extension TipsVM1{
//    
////    func GetHomeAllTips() async throws -> TipsAllM {
////        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
////            // Handle missings
////            throw NetworkError.unknown(code: 0, error: "check inputs")
////        }
////        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
////        print("param",parametersarr)
////        let target = TipsCategoryServices.GetAllMobile(parameters: parametersarr)
////            do {
////                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<TipsAllM>.self)
////                guard let model = result.data else {
////                    throw NetworkError.unknown(code: 0, error: "cant get result model")
////                }
//////                print("result.data",model)
////                return model
////
////            } catch {
////                throw error
////            }
////        
////    }
//    
////    func GetNewestTips() async throws -> [TipsNewestM]  {
////        let target = TipsCategoryServices.GetTipNewest
////            do {
////                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//////                print("result.data",result.data ?? [])
////                return result.data ?? []
////
////            } catch {
////                throw error
////            }
////        
////    }
//    
////    func GetInterestingTips() async throws -> [TipsNewestM]  {
////        let target = TipsCategoryServices.GetTipInterestYou
////            do {
////                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//////                print("result.data",result.data ?? [])
////                return result.data ?? []
////
////            } catch {
////                throw error
////            }
////        
////    }
////    func GetMostViewedTips() async throws -> [TipsNewestM]  {
////            let target = TipsCategoryServices.GetTipMostViewed
////            do {
////                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//////                print("result.data",result.data ?? [])
////                return result.data ?? []
////
////            } catch {
////                throw error
////            }
////        
////    }
//    
//
//    //MARK:  -- home that has pagination --
////    func getHomeTips()async throws {
////        do {
////            let response = try await GetHomeAllTips()
////            if skipCount == 0 {
////                allTipsResModel = response
////            }else{
////                allTipsResModel?.items?.append(contentsOf: response.items ?? [])
////            }
////            
////        } catch {
////            throw error
////        }
////    }
//
//    //MARK:  -- other functions has no pagination --
////    func getAllTips()async throws {
////        do {
////             try await getHomeTips()
////            newestTipsArr = try await GetNewestTips()
////            interestingTipsArr = try await GetInterestingTips()
////            mostViewedTipsArr = try await GetMostViewedTips()
////
////        } catch {
////            throw error
////        }
////    }
//}
