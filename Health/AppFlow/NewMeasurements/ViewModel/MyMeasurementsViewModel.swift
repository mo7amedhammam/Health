//
//  MyMeasurementsVM.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//

import Foundation

import Combine

class MyMeasurementsViewModel: ObservableObject {
    static let shared = MyMeasurementsViewModel()
    
    private let networkService: AsyncAwaitNetworkServiceProtocol

    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
    @Published var ArrStats: [ModelMyMeasurementsStats]? 
    @Published var ArrMeasurement: ModelMedicalMeasurements?
    @Published var ArrNormalRange: ModelMeasurementsNormalRange?
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Fetch Measurement Stats
    @MainActor
    func fetchStats() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewMeasurement.GetMyMeasurementsStats
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [ModelMyMeasurementsStats].self
            )
            self.ArrStats = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    
//    func fetchStats() {
//        isLoading = true
//        errorMessage = nil
//        defer { isLoading = false }
//        
//        let target = Measurement.GetMyMeasurementsStats
//        BaseNetwork.callApi(<#T##T#>, <#T##M#>, completion: <#T##(Result<M, NetworkError>) -> Void#>)(target, BaseResponse<[ModelMyMeasurementsStats]>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { [weak self] response in
//                if response.messageCode == 200 {
//                    self?.ArrStats = response.data ?? []
//                } else {
//                    self?.errorMessage = response.message ?? "Unexpected error"
//                }
//            })
//            .store(in: &cancellables)
//    }
    
    
    // MARK: - Parameters for Details
    var medicalMeasurementId: Int?
    var dateFrom: String?
    var dateTo: String?
    var maxResultCount = 15
    var skipCount = 0
    
//    func fetchMeasurementDetails() {
//        guard let medicalMeasurementId else { return }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        var parameters: [String: Any] = [
//            "medicalMeasurementId": medicalMeasurementId,
//            "maxResultCount": maxResultCount,
//            "skipCount": skipCount
//        ]
//        if let from = dateFrom { parameters["dateFrom"] = from }
//        if let to = dateTo { parameters["dateTo"] = to }
//
//        let target = Measurement.GetMyMedicalMeasurements(parameters: parameters)
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [MyFileM].self
//            )
//            self.files = response
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//
//        
//        
//        BaseNetwork.publisher(target, BaseResponse<ModelMedicalMeasurements>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { [weak self] response in
//                if response.messageCode == 200 {
//                    if self?.skipCount == 0 {
//                        self?.ArrMeasurement = response.data
//                    } else {
//                        self?.ArrMeasurement?.measurements?.items?.append(contentsOf: response.data?.measurements?.items ?? [])
//                    }
//                } else {
//                    self?.errorMessage = response.message ?? "Unexpected error"
//                }
//            })
//            .store(in: &cancellables)
//    }
    
    // MARK: - Fetch Normal Range
//    func fetchNormalRange() {
//        guard let id = medicalMeasurementId else { return }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        let target = Measurement.GetNormalRange(parameters: ["Id": id])
//        
//        BaseNetwork.publisher(target, BaseResponse<ModelMeasurementsNormalRange>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { [weak self] response in
//                if response.messageCode == 200 {
//                    self?.ArrNormalRange = response.data
//                } else {
//                    self?.errorMessage = response.message ?? "Unexpected error"
//                }
//            })
//            .store(in: &cancellables)
//    }
    
    // MARK: - Create Measurement
//    func createMeasurement(value: String, date: String, comment: String = "") {
//        guard let id = medicalMeasurementId else { return }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        var parameters: [String: Any] = [
//            "value": value,
//            "medicalMeasurementId": id,
//            "measurementDate": date
//        ]
//        if !comment.isEmpty {
//            parameters["comment"] = comment
//        }
//        
//        let target = Measurement.CreateMeasurement(parameters: parameters)
//        
//        BaseNetwork.publisher(target, BaseResponse<ModelCreateMeasurements>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { [weak self] response in
//                if response.messageCode != 200 {
//                    self?.errorMessage = response.message ?? "Unexpected error"
//                }
//            })
//            .store(in: &cancellables)
//    }
}
