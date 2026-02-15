//
//  DocSchedualeViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/08/2025.
//

import Foundation

class DocSchedualeViewModel : ObservableObject {
    static let shared = DocSchedualeViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil
    
    @Published var scheduales : [SchedualeM]? = nil
    @Published var schedualeDetails : SchedualeDetailsM?
    
    // Date range
    @Published var dateFrom: Date?
    @Published var dateTo: Date?
    
    // Success/Error states
    @Published var showSuccess: Bool = false
    @Published var DeleteSuccess: Bool = false
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension DocSchedualeViewModel{
    
    @MainActor
    func getMyScheduales() async {
        isLoading = true
        defer { isLoading = false }
        
        let target = DocSchedualesServices.GetDocSchedule
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [SchedualeM].self
            )
            self.scheduales = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getMySchedualeDetails(Id:Int?) async {
        isLoading = true
        defer { isLoading = false }
        
        var parameters : [String: Any] = [:]
        if let Id = Id{
            parameters = ["Id":Id]
        }
        let target = DocSchedualesServices.GetDocScheduleDetails(parameters: parameters)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: SchedualeDetailsM.self
            )
            self.schedualeDetails = response
            
            // Note: API doesn't return dates in the response, user must set them manually
            // Only update dates if they're actually returned and valid
            if let fromDateStr = response?.fromStartDate, !fromDateStr.isEmpty {
                self.dateFrom = fromDateStr.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")
            }
            if let toDateStr = response?.toEndDate, !toDateStr.isEmpty {
                self.dateTo = toDateStr.toDate(format: "yyyy-MM-dd'T'HH:mm:ss")
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func CreateOrUpdateScheduales() async {
        isLoading = true
        defer { isLoading = false }

        guard let details = schedualeDetails else {
            self.errorMessage = "No schedule details available"
            return
        }
        
        guard let dateFrom = dateFrom, let dateTo = dateTo else {
            self.errorMessage = "Please select date range"
            return
        }
        
        var dateDetailArray: [[String: Any]] = []

        if let scheduleId = details.doctorScheduleId, scheduleId > 0 {
            // Updating: send the same structure we received, but reflect current isSelected flags for shifts
            if let dayList = details.dayList {
                for day in dayList {
                    var dayDict: [String: Any] = [:]
                    if let id = day.id { dayDict["id"] = id }
                    if let dayId = day.dayId { dayDict["dayId"] = dayId }
                    if let name = day.name { dayDict["name"] = name }
                    if let isSelected = day.isSelected { dayDict["isSelected"] = isSelected }

                    let shiftObjects: [[String: Any]] = (day.shiftList ?? []).map { shift in
                        var shiftDict: [String: Any] = [:]
                        if let id = shift.id { shiftDict["id"] = id }
                        if let shiftId = shift.shiftId { shiftDict["shiftId"] = shiftId }
                        if let name = shift.name { shiftDict["name"] = name }
                        if let fromTime = shift.fromTime { shiftDict["fromTime"] = fromTime }
                        if let toTime = shift.toTime { shiftDict["toTime"] = toTime }
                        if let isSelected = shift.isSelected { shiftDict["isSelected"] = isSelected }
                        return shiftDict
                    }
                    dayDict["doctorScheduleDayShifts"] = shiftObjects
                    dateDetailArray.append(dayDict)
                }
            }
        } else {
            // Creating: send one day entry per selected day with its selected shifts
            var hasAnySelection = false
            
            if let dayList = details.dayList {
                for day in dayList where day.isSelected == true {
                    // Filter only selected shifts for this specific day
                    let selectedShifts: [[String: Any]] = (day.shiftList ?? [])
                        .filter { $0.isSelected == true }
                        .map { shift in
                            var shiftDict: [String: Any] = [:]
                            if let id = shift.id { shiftDict["id"] = id }
                            if let shiftId = shift.shiftId { shiftDict["shiftId"] = shiftId }
                            if let name = shift.name { shiftDict["name"] = name }
                            if let fromTime = shift.fromTime { shiftDict["fromTime"] = fromTime }
                            if let toTime = shift.toTime { shiftDict["toTime"] = toTime }
                            if let isSelected = shift.isSelected { shiftDict["isSelected"] = isSelected }
                            return shiftDict
                        }
                    
                    // Skip this day if no shifts are selected
                    if selectedShifts.isEmpty { continue }
                    
                    hasAnySelection = true
                    
                    // Create a separate day entry for each selected day
                    var dayDict: [String: Any] = [
                        "doctorScheduleDayShifts": selectedShifts
                    ]
                    if let dayId = day.dayId { dayDict["dayId"] = dayId }
                    if let name = day.name { dayDict["name"] = name }
                    if let isSelected = day.isSelected { dayDict["isSelected"] = isSelected }
                    
                    dateDetailArray.append(dayDict)
                }
            }

            if !hasAnySelection {
                self.errorMessage = "Please select at least one time shift"
                return
            }
        }

        // Ensure we have something to send
        if dateDetailArray.isEmpty {
            self.errorMessage = "Please select at least one time shift"
            return
        }
        
        let startDateStr = "\(dateFrom)".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss Z", FormatTo: "yyyy-MM-dd",outputLocal: .english)
        let endDateStr = "\(dateTo)".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss Z", FormatTo: "yyyy-MM-dd",outputLocal: .english)

        var parameters: [String: Any] = [
            "fromStartDate": startDateStr,
            "toEndDate": endDateStr,
            "doctorScheduleDays": dateDetailArray
        ]
        
        if let topId = details.id, topId > 0 { parameters["id"] = topId }
        if let scheduleId = details.doctorScheduleId, scheduleId > 0 { parameters["doctorScheduleId"] = scheduleId }
        
        print("📤 Sending schedule parameters:", parameters)

        let target = DocSchedualesServices.CreateDocSchedule(parameters: parameters)

        do {
            self.errorMessage = nil
            _ = try await networkService.request(target, responseType: AllergiesM.self)
            showSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Schedule creation error:", error)
        }
    }
    
    @MainActor
    func DeleteScheduale(Id:Int) async {
        isLoading = true
        defer { isLoading = false }

        let parameters: [String: Any] = ["Id": Id]

        let target = DocSchedualesServices.DeleteDocSchedule(parameters: parameters)

        do {
            self.errorMessage = nil
            _ = try await networkService.request(target, responseType: AllergiesM.self)
            DeleteSuccess = true
            scheduales?.remove(at: scheduales?.firstIndex(where: { $0.id == Id }) ?? -1)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Toggle shift selection for a specific day
    func toggleShift(dayId: Int, shiftId: Int) {
        guard let dayIndex = schedualeDetails?.dayList?.firstIndex(where: { $0.dayId == dayId }),
              let shiftIndex = schedualeDetails?.dayList?[dayIndex].shiftList?.firstIndex(where: { $0.shiftId == shiftId }) else {
            return
        }
        
        let currentSelection = schedualeDetails?.dayList?[dayIndex].shiftList?[shiftIndex].isSelected ?? false
        schedualeDetails?.dayList?[dayIndex].shiftList?[shiftIndex].isSelected = !currentSelection
        
        // Update day selection based on if any shifts are selected
        updateDaySelection(dayIndex: dayIndex)
    }
    
    // Toggle all shifts for a specific day
    func toggleDay(dayId: Int, selectAll: Bool) {
        guard let dayIndex = schedualeDetails?.dayList?.firstIndex(where: { $0.dayId == dayId }) else {
            return
        }
        
        schedualeDetails?.dayList?[dayIndex].isSelected = selectAll
        
        // Update all shifts for this day
        if let shiftsCount = schedualeDetails?.dayList?[dayIndex].shiftList?.count {
            for shiftIndex in 0..<shiftsCount {
                schedualeDetails?.dayList?[dayIndex].shiftList?[shiftIndex].isSelected = selectAll
            }
        }
    }
    
    // Update day selection based on shift selections
    private func updateDaySelection(dayIndex: Int) {
        let hasSelectedShifts = schedualeDetails?.dayList?[dayIndex].shiftList?.contains(where: { $0.isSelected == true }) ?? false
        schedualeDetails?.dayList?[dayIndex].isSelected = hasSelectedShifts
    }
    
    func clear() {
        self.scheduales = nil
        self.schedualeDetails = nil
        self.dateFrom = nil
        self.dateTo = nil
    }
    
    func clearSelections() {
        guard let dayList = schedualeDetails?.dayList else { return }
        
        for (dayIndex, _) in dayList.enumerated() {
            schedualeDetails?.dayList?[dayIndex].isSelected = false
            
            if let shiftsCount = schedualeDetails?.dayList?[dayIndex].shiftList?.count {
                for shiftIndex in 0..<shiftsCount {
                    schedualeDetails?.dayList?[dayIndex].shiftList?[shiftIndex].isSelected = false
                }
            }
        }
    }
    
    func refreshScheduales() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            await getMyScheduales()
        }
        await loadTask?.value
    }
}

// MARK: - Helper Extension
//extension String {
//    func toDate(format: String) -> Date? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter.date(from: self)
//    }
//}

