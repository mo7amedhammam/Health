//
//  TipsDetailsVM.swift
//  Health
//
//  Created by wecancity on 20/09/2023.
//

import Foundation

class TipsDetailsVM {
    // -- Get List --
    var maxResultCount: Int? = 10
    var skipCount: Int? = 0
    var categoryId: Int? = 0
    
    // -- Get Details --
    var tipId: Int? = 0
    
    var tipsByCategoryRes: TipsByCategoryM? = TipsByCategoryM()
    var tipDetailsRes : TipDetailsM? = TipDetailsM()
}

//MARK: -- Functions --
extension TipsDetailsVM{
    
    func GetTipsByCategory() async throws{
        guard let maxResultCount = maxResultCount, let skipCount = skipCount,let categoryId = categoryId else {
            // Handle missings
            throw NetworkError.unknown(code: 0, error: "check inputs")
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount,"categoryId" : categoryId]
        let target = TipsCategoryServices.getTipsByCategory(parameters: parametersarr)
        do {
            let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<TipsByCategoryM>.self)
            guard let model = result.data else {
                throw NetworkError.unknown(code: 0, error: "cant get result model")
            }
            //                print("result.data",model)
            //                return model
            if skipCount == 0 {
                tipsByCategoryRes = model
            }else{
                tipsByCategoryRes?.items?.append(contentsOf: model.items ?? [])
            }
            
        } catch {
            throw error
        }
        
    }
    
    func GetTipDetails() async throws{
        guard let tipId = tipId else {
            // Handle missings
            throw NetworkError.unknown(code: 0, error: "check inputs")
        }
        let parametersarr : [String : Any] =  ["Id" : tipId]
        let target = TipsCategoryServices.getTipDetails(parameters: parametersarr)
        do {
            let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<TipDetailsM>.self)
            guard let model = result.data else {
                throw NetworkError.unknown(code: 0, error: "cant get result model")
            }
//            return model
            tipDetailsRes = model
            
        } catch {
            throw error
        }
        
    }
    
}
