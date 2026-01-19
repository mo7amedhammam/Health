//
//  ReschedualeRequestViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 27/12/2025.
//
import AVFoundation

class ReschedualeRequestViewModel: ObservableObject {
    static let shared = ReschedualeRequestViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    private var loadTask : Task<Void, Never>? = nil
    // -- Get List --
    var maxResultCount: Int?              = 8
    @Published var skipCount: Int?        = 0
    
    // Published properties
    @Published var Requests: [UpcomingSessionM]?
    
//    @Published var showAddSheet: Bool = false
//    @Published var MainCategories: [CategoriyListItemM]?
//    @Published var selectedMainCategory: CategoriyListItemM?
//    
//    @Published var SubCategories: [CategoriyListItemM]?
//    @Published var selectedSubCategory: CategoriyListItemM?
//    
//    @Published var PackagesList: [SpecialityM]?
//    @Published var SelectedPackage: SpecialityM?
//    
//    // Countries
//    @Published var CountriesList: [AppCountryByPackIdM]?
//    // Legacy single selection (keep if some screens still bind to it)
//    @Published var selectedCountry: AppCountryByPackIdM?
//    // New: multiple country selection
//    @Published var selectedCountries: [AppCountryByPackIdM] = []
    
    @Published var showSuccess: Bool = false

    @Published var isLoading: Bool? = false
    @Published var canLoadMore: Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension ReschedualeRequestViewModel{
    
    @MainActor
    func getMyRequests() async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            isLoading = true
            defer { isLoading = false }
            
            let target = DocSchedualesServices.GetDocSchedule
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: [UpcomingSessionM].self
                )
                self.Requests = response
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
    
//    @MainActor
//    func AcceptRequest() async {
//        showSuccess.toggle()
//        isLoading = true
//        defer { isLoading = false }
//
//        let parameters: [String: Any] = [:]
//
//        let target = DocSchedualesServices.CreateDocSchedule(parameters: parameters)
//
//        do {
//            self.errorMessage = nil
//            _ = try await networkService.request(target, responseType: AllergiesM.self)
////            await getMyAllergies()
//            showSuccess = true
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    @MainActor
    func approuveCustomerRescheduleRequest(sessionId:Int?,Reject:Bool? = false) async { // approuve by doctor
        isLoading = true
        showSuccess = false
        defer { isLoading = false }
        // Validate required selections; adjust keys as needed for your API
        guard let sessionId = sessionId else {
            self.errorMessage = "check inputs"
            return
        }

        var parametersarr : [String : Any] =  ["Id":sessionId]
        if Reject == true {
            parametersarr["Reject"] = true
        }else{
            parametersarr["Reject"] = false
        }
        print("parametersarr",parametersarr)
        let target = HomeServices.ApprouveCustomerReschedualRequest(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            _ = try await networkService.request(
                target,
                responseType: [AvailableSchedualsM].self
            )
            showSuccess = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    
    func refreshRequests() async {
//            reset skip count in paginated
            await getMyRequests()
    }
    
}
