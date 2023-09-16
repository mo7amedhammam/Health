//
//  TipsVM.swift
//  Health
//
//  Created by wecancity on 16/09/2023.
//

import Foundation

class TipsVM {
    // -- Get List --
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    
    var allTipsResModel: TipsAllM? = TipsAllM()

    var newestTipsArr : [TipsNewestM]? = []
    var interestingTipsArr : [TipsNewestM]? = []
    var mostViewedTipsArr : [TipsNewestM]? = []

}

//MARK: -- Functions --
extension TipsVM{
    
    func GetAllTips(completion: @escaping (EventHandler?) -> Void) {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        completion(.loading)
        // Create your API request with the username and password
        let target = TipsCategoryServices.GetAllMobile(parameters: parametersarr)
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<TipsAllM>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                if self?.skipCount == 0 {
                    self?.allTipsResModel = response.data
                }else{
                    self?.allTipsResModel?.items?.append(contentsOf: response.data?.items ?? [])
                }
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
            
        }
    }
    
    
    func GetNewestTips(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = TipsCategoryServices.GetTipNewest
        
        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[TipsNewestM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")
                
                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                self?.newestTipsArr = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }
            
        }
    }
    
    func GetInterestingTips(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = TipsCategoryServices.GetTipInterestYou

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[TipsNewestM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                    self?.interestingTipsArr = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    func GetMostViewedTips(completion: @escaping (EventHandler?) -> Void) {
        // Create your API request with the username and password
        let target = TipsCategoryServices.GetTipMostViewed

        // Make the API call using your APIManager or networking code
        BaseNetwork.callApi(target, BaseResponse<[TipsNewestM]>.self) {[weak self] result in
            // Handle the API response here
            switch result {
            case .success(let response):
                // Handle the successful response
                print("request successful: \(response)")

                guard response.messageCode == 200 else {
                    completion(.error(0, (response.message ?? "check validations")))
                    return
                }
                    self?.mostViewedTipsArr = response.data
                completion(.success)
            case .failure(let error):
                // Handle the error
                print("Login failed: \(error.localizedDescription)")
                completion(.error(0, "\(error.localizedDescription)"))
            }

        }
    }
    
    //MARK: -- Individual Function Calls --
    func fetchAllTips(completion: @escaping (EventHandler?) -> Void) {
        Task {
            do {
                try await GetAllTips { [weak self] allHandler in
                    guard let self = self, let allHandler = allHandler else { return }
                    switch allHandler {
                    case .success:
                        // Handle success for GetNewestTips
                        print("Newest tips fetched successfully")
                    case .error(let code, let message):
                        // Handle error for GetNewestTips
                        print("Error fetching newest tips: \(message)")
                    case .loading:
                        // Handle loading state for GetNewestTips
                        print("Fetching newest tips...")
                    case .stopLoading:
                        // Handle stop loading state for GetNewestTips
                        print("Stop loading newest tips...")
                    case .none:
                        print("None newest tips...")
                    }
                }

                try await GetNewestTips { [weak self] newestHandler in
                    guard let self = self, let newestHandler = newestHandler else { return }
                    switch newestHandler {
                    case .success:
                        // Handle success for GetNewestTips
                        print("Newest tips fetched successfully")
                    case .error(_, let message):
                        // Handle error for GetNewestTips
                        print("Error fetching newest tips: \(message)")
                    case .loading:
                        // Handle loading state for GetNewestTips
                        print("Fetching newest tips...")
                    case .stopLoading:
                        // Handle stop loading state for GetNewestTips
                        print("Stop loading newest tips...")
                    case .none:
                        print("None newest tips...")
                    }
                }

                try await GetInterestingTips { [weak self] interestingHandler in
                    guard let self = self, let interestingHandler = interestingHandler else { return }

                    switch interestingHandler {
                    case .success:
                        // Handle success for GetInterestingTips
                        print("Interesting tips fetched successfully")
                    case .error(_, let message):
                        // Handle error for GetInterestingTips
                        print("Error fetching interesting tips: \(message)")
                    case .loading:
                        // Handle loading state for GetInterestingTips
                        print("Fetching interesting tips...")
                    case .stopLoading:
                        // Handle stop loading state for GetInterestingTips
                        print("Stop loading newest tips...")
                    case .none:
                        print("None newest tips...")
                    }
                }

                try await GetMostViewedTips { [weak self] mostViewedHandler in
                    guard let self = self, let mostViewedHandler = mostViewedHandler else { return }

                    switch mostViewedHandler {
                    case .success:
                        // Handle success for GetMostViewedTips
                        print("Most viewed tips fetched successfully")
                    case .error(_, let message):
                        // Handle error for GetMostViewedTips
                        print("Error fetching most viewed tips: \(message)")
                    case .loading:
                        // Handle loading state for GetMostViewedTips
                        print("Fetching most viewed tips...")
                    case .stopLoading:
                        // Handle stop loading state for GetMostViewedTips
                        print("Stop loading newest tips...")
                    case .none:
                        print("None newest tips...")
                    }
                }

                completion(.success)
            } catch {
                completion(.error(0, error.localizedDescription))
            }
        }
    }
    
}
