//
//  AlmostFinishedVM.swift
//  Sehaty
//
//  Created by wecancity on 09/10/2023.
//

import Foundation

class AlmostFinishedVM {
    // -- Get List --
    var maxResultCount: Int? = 5
    var skipCount: Int?      = 0
    
    var responseModel: AlmostFinishedPrescriptionM? = AlmostFinishedPrescriptionM()
}

//MARK: -- Functions --
extension AlmostFinishedVM{
    
    func GetAlmostFinishedPresc() async throws -> AlmostFinishedPrescriptionM {
        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
            // Handle missings
            throw NetworkError.unknown(code: 0, error: "check inputs")
        }
        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
        print("param",parametersarr)
        let target = TipsCategoryServices.getAlmostFinishedPresc(parameters: parametersarr)
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<AlmostFinishedPrescriptionM>.self)
                guard let model = result.data else {
                    throw NetworkError.unknown(code: 0, error: "cant get result model")
                }
//                print("result.data",model)
                return model

            } catch {
                throw error
            }
    }
    
   func getHomeAlmostFinish()async throws {
       do {
           let response = try await GetAlmostFinishedPresc()
           if skipCount == 0 {
               responseModel = response
           } else {
               responseModel?.items?.append(contentsOf: response.items ?? [])
           }
           
       } catch {
           throw error
       }
   }

    //MARK:  -- other functions has no pagination --
//    func getAllTips()async throws {
//        do {
//             try await getHomeTips()
//            responseModel = try await GetNewestTips()
//            interestingTipsArr = try await GetInterestingTips()
//            mostViewedTipsArr = try await GetMostViewedTips()
//
//        } catch {
//            throw error
//        }
//    }
}
