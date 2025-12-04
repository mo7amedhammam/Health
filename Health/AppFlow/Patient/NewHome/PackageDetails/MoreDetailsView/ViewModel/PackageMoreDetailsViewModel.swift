//
//  PackageMoreDetailsViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 18/05/2025.
//

import Foundation

final class PackageMoreDetailsViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // MARK: - Inputs
    var doctorPackageId: Int?
    var appCountryId: Int?{return Helper.shared.AppCountryId()}
    // Month anchor for fetching days
    @Published var newDate: Date = Date()
    
    // MARK: - Outputs
    @Published var packageDetails: PackageMoreDetailsM?
    
    @Published var availableDays: [AvailableDayM] = []
    @Published var availableShifts: [AvailableTimeShiftM] = []
    @Published var availableScheduals: [AvailableSchedualsM] = []

    @Published var selectedDay: AvailableDayM?
    @Published var selectedShift: AvailableTimeShiftM?
    @Published var selectedSchedual: AvailableSchedualsM?

    @Published var ticketData: TicketM?

    @Published var isReschedualed: Bool? = false

    // Important: Optional Bool? with public setter to match `showHud2` Binding<Bool?>
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil

    // MARK: - Caching
    private struct DaysKey: Hashable {
        let doctorId: Int
        let appCountryId: Int
        let month: String // yyyy-MM
    }
    private struct SchedulesKey: Hashable {
        let doctorId: Int
        let packageId: Int
        let appCountryId: Int
        let shiftId: Int
        let date: String // yyyy-MM-dd
    }

    private var daysCache: [DaysKey: [AvailableDayM]] = [:]
    private var shiftsCache: [Int: [AvailableTimeShiftM]] = [:] // key: appCountryPackageId
    private var schedulesCache: [SchedulesKey: [AvailableSchedualsM]] = [:]

    // MARK: - Tasks & Loading
    private var detailsTask: Task<Void, Never>?
    private var daysTask: Task<Void, Never>?
    private var shiftsTask: Task<Void, Never>?
    private var schedulesTask: Task<Void, Never>?

    private var loadingCount: Int = 0
    private func startLoading() {
        loadingCount += 1
        isLoading = true
    }
    private func stopLoading() {
        loadingCount = max(0, loadingCount - 1)
        if loadingCount == 0 { isLoading = false }
    }

    // MARK: - Init
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }

    deinit {
        detailsTask?.cancel()
        daysTask?.cancel()
        shiftsTask?.cancel()
        schedulesTask?.cancel()
    }

    // MARK: - Orchestration
    func load(doctorPackageId: Int) async {
        self.doctorPackageId = doctorPackageId
        await fetchDoctorPackageDetails()
        await fetchAvailableDays(for: newDate, force: false)
    }

    func onMonthChanged() async {
        await MainActor.run {
            selectedDay = nil
            selectedShift = nil
            selectedSchedual = nil
            availableShifts = []
            availableScheduals = []
        }
        await fetchAvailableDays(for: newDate, force: false)
    }

    func select(day: AvailableDayM) async {
        // Avoid redundant work
        if await MainActor.run(resultType: Bool.self, body: {
            if selectedDay == day { return true }
            selectedDay = day
            selectedShift = nil
            selectedSchedual = nil
            availableScheduals = []
            return false
        }) { return }
        await fetchAvailableShifts(force: false)
    }

    func select(shift: AvailableTimeShiftM) async {
        // Avoid redundant work
        if await MainActor.run(resultType: Bool.self, body: {
            if selectedShift == shift { return true }
            selectedShift = shift
            selectedSchedual = nil
            return false
        }) { return }
        await fetchAvailableScheduals(force: false)
    }

    // MARK: - Fetchers
    private func fetchDoctorPackageDetails() async {
        detailsTask?.cancel()
        await MainActor.run { errorMessage = nil }

        guard let appCountryId = appCountryId else { return }

        var params: [String: Any] = [ "AppCountryId": appCountryId]
        if let doctorPackageId = doctorPackageId {
            params["Id"] = doctorPackageId
        }else{
            if let doctorPackageId = packageDetails?.id{
                params["Id"] = doctorPackageId
            }
        }
        let target = HomeServices.GetDoctorPackageById(parameters: params)

        detailsTask = Task {
            await MainActor.run { self.startLoading() }
            defer { Task { await MainActor.run { self.stopLoading() } } }

            do {
                let response = try await networkService.request(target, responseType: PackageMoreDetailsM.self)
                await MainActor.run {
                    self.packageDetails = response
                }
            } catch {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        await detailsTask?.value
    }

    private func fetchAvailableDays(for date: Date, force: Bool) async {
        daysTask?.cancel()
        await MainActor.run { errorMessage = nil }

        guard let doctorId = await MainActor.run(body: { packageDetails?.doctorData?.doctorID }),
              let appCountryId = appCountryId else { return }

        let monthKey = date.formatted(.customDateFormat("yyyy-MM"))
        let cacheKey = DaysKey(doctorId: doctorId, appCountryId: appCountryId, month: monthKey)

        if !force, let cached = daysCache[cacheKey] {
            await MainActor.run { self.availableDays = cached }
            return
        }

        let dayParam = date.formatted(.customDateFormat("yyyy-MM-dd"))
        let params: [String: Any] = ["date": dayParam, "doctorId": doctorId, "appCountryId": appCountryId]
        let target = HomeServices.GetDoctorAvailableDayList(parameters: params)
print("params:///", params)
        daysTask = Task {
            await MainActor.run { self.startLoading() }
            defer { Task { await MainActor.run { self.stopLoading() } } }

            do {
                let response = try await networkService.request(target, responseType: [AvailableDayM].self)
                // Update cache and state on main
                await MainActor.run {
                    self.daysCache[cacheKey] = response
                    self.availableDays = response ?? []
                }
            } catch {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        await daysTask?.value
    }

    private func fetchAvailableShifts(force: Bool) async {
        shiftsTask?.cancel()
        await MainActor.run { errorMessage = nil }

//        guard let appCountryPackageId = await MainActor.run(body: { packageDetails?.packageData?.appCountryPackageId }) else { return }
        guard let appCountryId = appCountryId else { return }

        if !force, let cached = shiftsCache[appCountryId] {
            await MainActor.run { self.availableShifts = cached }
            return
        }

        let params: [String: Any] = ["AppCountryId": appCountryId]
        let target = HomeServices.GetTimeShiftScheduleList(parameters: params)

        shiftsTask = Task {
            await MainActor.run { self.startLoading() }
            defer { Task { await MainActor.run { self.stopLoading() } } }

            do {
                let response = try await networkService.request(target, responseType: [AvailableTimeShiftM].self)
                await MainActor.run {
                    self.shiftsCache[appCountryId] = response
                    self.availableShifts = response ?? []
                }
            } catch {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        await shiftsTask?.value
    }

    private func fetchAvailableScheduals(force: Bool) async {
        schedulesTask?.cancel()
        await MainActor.run { errorMessage = nil }

        // Collect inputs safely on main actor
        let inputs = await MainActor.run { () -> (appCountryId: Int, packageId: Int, doctorId: Int, shiftId: Int, dateString: String)? in
            guard
                let appCountryId = appCountryId,
                let packageId = packageDetails?.packageData?.packageID,
                let doctorId = packageDetails?.doctorData?.doctorID,
                let shiftId = selectedShift?.id
            else { return nil }

            let dateString =
            selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd",outputLocal: .english)
                ?? newDate.formatted(.customDateFormat("yyyy-MM-dd"))

            return (appCountryId, packageId, doctorId, shiftId, dateString)
        }
        guard let inputs else { return }

        let cacheKey = SchedulesKey(doctorId: inputs.doctorId, packageId: inputs.packageId, appCountryId: inputs.appCountryId, shiftId: inputs.shiftId, date: inputs.dateString)

        if !force, let cached = schedulesCache[cacheKey] {
            await MainActor.run { self.availableScheduals = cached }
            return
        }

        let params: [String: Any] = [
            "appCountryId": inputs.appCountryId,
            "date": inputs.dateString,
            "packageId": inputs.packageId,
            "doctorId": inputs.doctorId,
            "shiftId": inputs.shiftId
        ]
        let target = HomeServices.GetAvailableDoctorSchedule(parameters: params)

        schedulesTask = Task {
            await MainActor.run { self.startLoading() }
            defer { Task { await MainActor.run { self.stopLoading() } } }

            do {
                let response = try await networkService.request(target, responseType: [AvailableSchedualsM].self)
                await MainActor.run {
                    self.schedulesCache[cacheKey] = response
                    self.availableScheduals = response ?? []
                }
            } catch {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        await schedulesTask?.value
    }

    // MARK: - Booking
    func getBookingSession() async {
//        guard let params = await prepareParamters() else { return }
        guard let params = await prepareParamters() else { return }
        await MainActor.run { errorMessage = nil; startLoading() }
        defer { Task { await MainActor.run { self.stopLoading() } } }

        let target = HomeServices.GetBookingSession(parameters: params)

        do {
            let response = try await networkService.request(target, responseType: TicketM.self)
            await MainActor.run { self.ticketData = response }
        } catch {
            await MainActor.run { self.errorMessage = error.localizedDescription }
        }

    }

    
//    @MainActor
//    func prepareParametersForAddingSession() -> [String: Any]? {
//        guard
//            let packageId = packageDetails?.packageData?.packageID,
//            let doctorId = packageDetails?.doctorData?.doctorID,
//            let doctorPackageId = packageDetails?.id,
//            let shiftId = selectedShift?.id,
//            let timeFrom = selectedSchedual?.timefrom,
//            let timeTo = selectedSchedual?.timeTo,
//            let dateRaw = selectedDay?.date
//        else {
//            return nil
//        }
//
//        // Convert date → ISO8601 "yyyy-MM-dd'T'HH:mm:ss"
//        let formattedDate = dateRaw.ChangeDateFormat(
//            FormatFrom: "yyyy-MM-dd'T'HH:mm:ss",
//            FormatTo: "yyyy-MM-dd'T'HH:mm:ss"
//        )
//
//        var params: [String: Any] = [
//            "doctorPackageId": doctorPackageId,
//            "doctorId": doctorId,
//            "packageId": packageId,
//            "date": formattedDate,
//            "shiftId": shiftId,
//            "timeFrom": timeFrom,
//            "timeTo": timeTo
//        ]
//
//        // Add coupon only if user typed something
////        if let coupon = couponeCode, !coupon.isEmpty {
////            params["coupon"] = coupon
////        }
//
//        return params
//    }
    
    @MainActor
    func prepareParamters() -> [String: Any]? {
        // Ensure we read state on main actor
//        return MainActor.assumeIsolated { () -> [String: Any]? in
            guard
                let appCountryPackageId = packageDetails?.appCountryPackageId,
                let packageId = packageDetails?.packageData?.packageID,
                let doctorId = packageDetails?.doctorData?.doctorID,
                let shiftId = selectedShift?.id,
                let doctorPackageId = packageDetails?.id,
//                let totalAfterDiscount = packageDetails?.packageData?.priceAfterDiscount,
                let timeFrom = selectedSchedual?.timefrom,
                let timeTo = selectedSchedual?.timeTo,
                let date = selectedDay?.date?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "yyyy-MM-dd",outputLocal: .english)
            else {
                return nil
            }

            return [
                "date": date,
                "packageId": packageId,
                "doctorId": doctorId,
                "doctorPackageId": doctorPackageId,
                "shiftId": shiftId,
//                "totalAfterDiscount": totalAfterDiscount,
                "timeFrom": timeFrom,
                "timeTo": timeTo,
                "appCountryPackageId": appCountryPackageId
            ]
//        }
    }
}

