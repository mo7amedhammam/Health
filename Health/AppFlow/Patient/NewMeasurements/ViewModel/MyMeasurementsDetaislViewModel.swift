//
//  MyMeasurementsDetaislViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/07/2025.
//

import Foundation

//import Combine

class MyMeasurementsDetaislViewModel: ObservableObject {
    static let shared = MyMeasurementsDetaislViewModel()
    
    private let networkService: AsyncAwaitNetworkServiceProtocol
    var customerId:Int? = nil
    @Published var currentStats:MyMeasurementsStatsM?
    @Published var isPresentingNewMeasurementSheet = false{didSet{errorMessage = nil}}
    @Published var isMeasurementAdded:Bool = false
    
    // Published properties to bind with SwiftUI
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String?
//    @Published var ArrStats: [ModelMyMeasurementsStats]?
    @Published var ArrMeasurement: ModelMedicalMeasurements?
    @Published var ArrNormalRange: ModelMeasurementsNormalRange?
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Parameters for Details
//    var medicalMeasurementId: Int?
    @Published var dateFrom: Date?
    @Published var dateTo: Date?
    var maxResultCount:Int = 10
    @Published var skipCount = 0
    
    @MainActor
    func fetchMeasurementDetails() async {
        guard let medicalMeasurementId = currentStats?.medicalMeasurementID else { return }
        var parameters: [String: Any] = [
            "medicalMeasurementId": medicalMeasurementId,
            "maxResultCount": maxResultCount,
            "skipCount": skipCount
        ]
        if let formatteddate = dateFrom?.formatDate(format: "yyyy-MM-dd") {
            parameters["dateFrom"] = formatteddate
        }
//        if dateTo != nil {
        if let formatteddate = dateTo?.formatDate(format: "yyyy-MM-dd") {
            parameters["dateTo"]   = formatteddate
        }
        if let customerId = customerId{
            parameters["customerId"] = customerId
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        let target = NewMeasurement.GetMyMedicalMeasurements(parameters: parameters)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: ModelMedicalMeasurements.self
            )
            if skipCount == 0 {
                self.ArrMeasurement = response
            }else{
                let existingItems = self.ArrMeasurement?.measurements?.items ?? []
                let newItems = response?.measurements?.items ?? []
                self.ArrMeasurement?.measurements?.items = mergedMeasurements(existing: existingItems, new: newItems)
                self.ArrMeasurement?.measurements?.totalCount = response?.measurements?.totalCount ?? self.ArrMeasurement?.measurements?.totalCount
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Fetch Normal Range
        @MainActor
        func fetchNormalRange() async {
            guard let id = currentStats?.medicalMeasurementID else { return }

            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
    
            var parameters: [String: Any] = ["Id": id]
            
            if let customerId = customerId{
                parameters["CustomerId"] = customerId
            }
            let target = NewMeasurement.GetNormalRange(parameters: parameters )
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: ModelMeasurementsNormalRange.self
                )
                self.ArrNormalRange = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
            }
    
    // MARK: - Create Measurement
    @Published var value:String = ""
    @Published var date:Date?{
        didSet{
            guard let date = date else { return }
            formatteddate = date.formatDate(format: "yyyy-MM-dd hh:mm a")
        }
    }
    @Published var formatteddate:String = ""

    @Published var comment:String = ""
    
    @MainActor
    func createMeasurement() async {
        guard let id = currentStats?.medicalMeasurementID else { return }
        guard value.count > 0  else {
            self.errorMessage = "please_enter_measurement_value".localized
            return }
        guard let date = date?.formatDate(format: "yyyy-MM-dd'T'HH:mm:ss") else {
            self.errorMessage = "please_select_measurement_date".localized
            return }
      
        // Validate value with regex
            if let regexPattern = currentStats?.regExpression {
                let regex = try? NSRegularExpression(pattern: regexPattern)
                let range = NSRange(location: 0, length: value.utf16.count)
                let matches = regex?.firstMatch(in: value, options: [], range: range) != nil

                if !matches {
                    self.errorMessage = "invalid_format".localized + " " + "Try_again_with".localized + " \(currentStats?.regExpression ?? "") "
                    return
                }
            }
        isMeasurementAdded = false
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        var parameters: [String: Any] = [
            "value": value,
            "medicalMeasurementId": id,
            "measurementDate": date
        ]
        if let customerId = customerId{
            parameters["customerId"] = customerId
        }
        if comment.count > 0 {
            parameters["comment"] = comment
        }
        let target = NewMeasurement.CreateMeasurement(parameters: parameters)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: ModelCreateMeasurements.self
            )
            if let current = currentStats?.measurementsCount {
                currentStats?.measurementsCount = current + 1
                skipCount = 0
                await fetchMeasurementDetails()
            }
            clearNewMeasurement()
            isPresentingNewMeasurementSheet = false
            isMeasurementAdded = true
//            self.ArrNormalRange = response
            
        } catch {
            self.errorMessage = error.localizedDescription
        }

    }
    func clearNewMeasurement() {
        value = ""
        date = nil
        formatteddate = ""
        comment = ""
    }

    private func mergedMeasurements(existing: [Item], new: [Item]) -> [Item] {
        var seen = Set<String>()
        var merged: [Item] = []

        for item in existing + new {
            let key = measurementKey(for: item)
            guard seen.insert(key).inserted else { continue }
            merged.append(item)
        }

        return merged
    }

    private func measurementKey(for item: Item) -> String {
        if let id = item.id {
            return "id:\(id)"
        }

        return [
            item.date ?? "",
            item.value ?? "",
            "\(item.customerID ?? -1)",
            "\(item.medicalMeasurementID ?? -1)"
        ].joined(separator: "|")
    }
}

extension MyMeasurementsDetaislViewModel {
    
    @MainActor
    func refresh() async {
        skipCount = 0
        isLoading = true
        defer { isLoading = false }
//        async let normalRang: () = fetchNormalRange()
        async let details: () = fetchMeasurementDetails()

         _ = await (details)
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = ArrMeasurement?.measurements?.items?.count,
              let totalCount = ArrMeasurement?.measurements?.totalCount,
              currentCount < totalCount else { return }

        skipCount = (skipCount) + maxResultCount
        await fetchMeasurementDetails()
    }
    
    func clear() {
        skipCount = 0
        ArrMeasurement = nil
    }
}
