//
//  File.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/07/2025.
//


    // MARK: - Parameters for Details
    var medicalMeasurementId: Int?
    var dateFrom: String?
    var dateTo: String?
    var maxResultCount = 15
    @Published var skipCount = 0
    
    @MainActor
    func fetchMeasurementDetails() async {
        guard let medicalMeasurementId = medicalMeasurementId else { return }
        var parameters: [String: Any] = [
            "medicalMeasurementId": medicalMeasurementId,
            "maxResultCount": maxResultCount,
            "skipCount": skipCount
        ]
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
            self.ArrMeasurement = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Fetch Normal Range
        @MainActor
        func fetchNormalRange() async {
            guard let id = medicalMeasurementId else { return }

            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
    
            let target = NewMeasurement.GetNormalRange(parameters: ["Id": id])
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
    @Published var value:String?
    @Published var date:String?
    @Published var comment:String?
    
    @MainActor
    func createMeasurement() async {
        guard let id = medicalMeasurementId,let value = value,let date = date  else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        var parameters: [String: Any] = [
            "value": value,
            "medicalMeasurementId": id,
            "measurementDate": date
        ]
        if let comment = comment {
            parameters["comment"] = comment
        }
        let target = NewMeasurement.CreateMeasurement(parameters: parameters)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: ModelCreateMeasurements.self
            )
//            self.ArrNormalRange = response
           await fetchStats()
        } catch {
            self.errorMessage = error.localizedDescription
        }

    }
}
