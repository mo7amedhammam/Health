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
    
    @Published var scheduales : [SchedualeM]? = SchedualeM.mockList

    @Published var selectedSlots: [String: Set<TimeSlot>] = [:]

    let days = ["السبت", "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"]

    let slots: [TimeSlot] = [
        TimeSlot(title: "فترة صباحية", time: "9:00 am - 2:00 pm"),
        TimeSlot(title: "بعد الظهر", time: "2:00 pm - 7:00 pm"),
        TimeSlot(title: "فترة مسائية", time: "7:00 pm - 12:00 am")
    ]
    
//    @Published var allergies : AllergiesM?

    @Published var addAllergies : AllergiesM?

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
    func CreateOrUpdateScheduales() async {
//        {
//          "doctorId": 0,
//          "startDate": "2025-12-01T13:55:23.200Z",
//          "endDate": "2025-12-01T13:55:23.200Z",
//          "dateDetail": [
//            {
//              "dayId": 0,
//              "timeShiftId": [
//                0
//              ]
//            }
//          ]
//        }
        showSuccess.toggle()
        isLoading = true
        defer { isLoading = false }

        let parameters: [String: Any] = ["allergyId": Array(selectedSlots)]

        let target = DocSchedualesServices.CreateDocSchedule(parameters: parameters)

        do {
            self.errorMessage = nil
            _ = try await networkService.request(target, responseType: AllergiesM.self)
//            await getMyAllergies()
            showSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func DeleteScheduale() async {
        showSuccess.toggle()
        isLoading = true
        defer { isLoading = false }

        let parameters: [String: Any] = ["Id": Array(selectedSlots)]

        let target = DocSchedualesServices.DeleteDocSchedule(parameters: parameters)

        do {
            self.errorMessage = nil
            _ = try await networkService.request(target, responseType: AllergiesM.self)
//            await getMyAllergies()
            DeleteSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getMySchedualeShift() async {
        isLoading = true
        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyAllergiesServices.GetAllergies
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: AllergiesM.self
            )
//            self.allergies = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func toggleSlot(day: String, slot: TimeSlot) {
        var daySlots = selectedSlots[day, default: []]
        if daySlots.contains(slot) {
            daySlots.remove(slot)
        } else {
            daySlots.insert(slot)
        }
        selectedSlots[day] = daySlots
    }
    
    func clear() {
        self.scheduales = nil
        selectedSlots.removeAll()
    }
}
