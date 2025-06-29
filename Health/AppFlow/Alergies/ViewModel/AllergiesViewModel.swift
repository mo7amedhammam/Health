//
//  AllergiesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//
import Foundation

class AllergiesViewModel : ObservableObject {
    static let shared = AllergiesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
//    Add file
//    @Published private var fileName: String? = ""
//    @Published private var fileType: FileTypeM? = nil
//    @Published private var fileLink: String? = ""

//    @Published private var image: UIImage?
//    @Published private var fileURL: URL?
        
    // Published properties
    @Published var allergies : AllergiesM?

    @Published var addAllergies : AllergiesM?

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension AllergiesViewModel{
    
//    @MainActor
//    func addNewAllergies(selectedIds: Set<Int>, langId: Int = 1) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        guard let allergies = self.allergies else { return }
//
//        let payloadArray: [[String: Any]] = allergies.compactMap { category in
//            guard let categoryId = category.allergyCategoryID else { return nil }
//
//            let matchedAllergies = (category.allergyList ?? []).filter { allergy in
//                selectedIds.contains(allergy.id ?? -1)
//            }
//
//            guard !matchedAllergies.isEmpty else { return nil }
//
//            let nameList: [[String: Any]] = matchedAllergies.compactMap { allergy in
//                guard let name = allergy.name else { return nil }
//                return [
//                    "langId": langId,
//                    "fieldName": name,
//                    "fieldText": name
//                ]
//            }
//
//            return [
//                "allergyCategoryId": categoryId,
//                "nameList": nameList
//            ]
//        }
//
//        let parameters: [String: Any] = ["allergies": payloadArray]
//
//        let target = MyAllergiesServices.AddAllergies(parameters: parameters)
//
//        do {
//            self.errorMessage = nil
//            _ = try await networkService.request(target, responseType: AllergiesM.self)
//            await getMyAllergies()
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
    @MainActor
    func addNewAllergies(selectedIds: Set<Int>) async {
        isLoading = true
        defer { isLoading = false }

        let parameters: [String: Any] = ["allergyId": Array(selectedIds)]

        let target = MyAllergiesServices.AddAllergies(parameters: parameters)

        do {
            self.errorMessage = nil
            _ = try await networkService.request(target, responseType: AllergiesM.self)
//            await getMyAllergies()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    @MainActor
    func getMyAllergies() async {
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
            self.allergies = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}

//extension AllergiesViewModel {
//
//    @MainActor
//    func refresh() async {
//        skipCount = 0
//        await getAppointmenstList()
//    }
//
//    @MainActor
//    func loadMoreIfNeeded() async {
//        guard !(isLoading ?? false),
//              let currentCount = appointments?.items?.count,
//              let totalCount = appointments?.totalCount,
//              currentCount < totalCount,
//              let maxResultCount = maxResultCount else { return }
//
//        skipCount = (skipCount ?? 0) + maxResultCount
//        await getAppointmenstList()
//    }
//}
