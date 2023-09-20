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
    
    func GetHomeAllTips() async throws -> TipsAllM {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            throw NetworkError.unknown(code: 0, error: "check inputs")
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        print("param",parametersarr)
        let target = TipsCategoryServices.GetAllMobile(parameters: parametersarr)
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<TipsAllM>.self)
                guard let model = result.data else {
                    throw NetworkError.unknown(code: 0, error: "cant get result model")
                }
//                print("result.data",model)
                return model

            } catch {
                throw error
            }
        
    }
    
    func GetNewestTips() async throws -> [TipsNewestM]  {
        let target = TipsCategoryServices.GetTipNewest
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//                print("result.data",result.data ?? [])
                return result.data ?? []

            } catch {
                throw error
            }
        
    }
    
    func GetInterestingTips() async throws -> [TipsNewestM]  {
        let target = TipsCategoryServices.GetTipInterestYou
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//                print("result.data",result.data ?? [])
                return result.data ?? []

            } catch {
                throw error
            }
        
    }
    func GetMostViewedTips() async throws -> [TipsNewestM]  {
            let target = TipsCategoryServices.GetTipMostViewed
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[TipsNewestM]>.self)
//                print("result.data",result.data ?? [])
                return result.data ?? []

            } catch {
                throw error
            }
        
    }
    

    //MARK:  -- home that has pagination --
    func getHomeTips()async throws {
        do {
            let response = try await GetHomeAllTips()
            if skipCount == 0 {
                allTipsResModel = response
            }else{
                allTipsResModel?.items?.append(contentsOf: response.items ?? [])
            }
            
        } catch {
            throw error
        }
    }

    //MARK:  -- other functions has no pagination --
    func getAllTips()async throws {
        do {
             try await getHomeTips()
            newestTipsArr = try await GetNewestTips()
            interestingTipsArr = try await GetInterestingTips()
            mostViewedTipsArr = try await GetMostViewedTips()

        } catch {
            throw error
        }
    }
}
