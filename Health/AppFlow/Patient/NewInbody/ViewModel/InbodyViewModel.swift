//
//  InbodyViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/08/2025.
//

import Foundation
import UIKit

class InbodyViewModel:ObservableObject {
    static let shared = InbodyViewModel()
    private let networkService: AsyncAwaitNetworkServiceProtocol
    private var loadTask: Task<Void,Never>? = nil
    
    // -- Get List --
    var maxResultCount: Int? = 10
    @Published var skipCount: Int? = 0
    
    @Published var files: InbodyListM? = InbodyListM()
    
    // -- Add Record --
    @Published var showAddSheet:Bool = false{didSet{errorMessage=nil}}
    @Published var fileName:String = ""
    @Published var image:UIImage?
    @Published var fileURL:URL?
    @Published var date: Date? = Date(){
        didSet{
            formattedDate = date?.formatDate(format: "yyyy-MM-dd") ?? ""
        }
    }
    @Published var formattedDate:String = ""

    @Published var Comment:String=""

//    var CustomerId : Int? = Helper.shared.getUser()?.id // required
    @Published var addresponseModel: InbodyListItemM? = InbodyListItemM()
  
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
//    @Published var CreationErrorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }

}


//MARK: -- Functions --
extension InbodyViewModel{
    
    @MainActor
    func addNewInbody() async {

        isLoading = true
        defer { isLoading = false }
        defer { fileURL?.stopAccessingSecurityScopedResource() }
        
        // Validate required inputs: date and either image or file
        // Date required
        if formattedDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.errorMessage = "please_select_date".localized
            return
        }
        // Either image or file required
        if image == nil && fileURL == nil {
            self.errorMessage = "please_select_image_or_file".localized
            return
        }
        
        var parametersarr : [String : Any] =  ["Date" : formattedDate]

        if Comment.count > 0 {
            parametersarr["Comment"] = Comment
        }
        
        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
            MultipartFormDataPart(name: key, value: "\(value)")
        }
        
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            parts.append(
                MultipartFormDataPart(
                    name: "TestFile",
                    filename: "TestFile.jpg",
                    mimeType: "image/jpeg",
                    data: imageData
                )
            )
        }
        else if let fileURL = fileURL {
            // Start security-scoped access for file URL if needed
            _ = fileURL.startAccessingSecurityScopedResource()
            do {
                let fileData = try Data(contentsOf: fileURL)
                let fileName = fileURL.lastPathComponent
                let mimeType = "application/pdf"

                parts.append(
                    MultipartFormDataPart(
                        name: "TestFile",
                        filename: fileName,
                        mimeType: mimeType,
                        data: fileData
                    )
                )
            } catch {
                print("Failed to read file: \(error)")
                self.errorMessage = error.localizedDescription
                return
            }
        }
        
        let target = NewAuthontications.CreateCustomerInboy(parameters: parametersarr)
        do {
            self.errorMessage = nil
            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: InbodyListItemM.self)
            clear()
            await getInbodyList()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    @MainActor
    func getInbodyList() async {
        // Cancel any in-flight unified load to prevent overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }

            isLoading = true
            defer { isLoading = false }
            guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
                // Handle missing username or password
                return
            }
            let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
            
            // Create your API request with the username and password
            let target = NewAuthontications.GetCustomerInbody(parameters: parametersarr)
            do {
                self.errorMessage = nil // Clear previous errors
                let response = try await networkService.request(
                    target,
                    responseType: InbodyListM.self
                )
                if skipCount == 0 {
                    self.files = response
                }else{
                    self.files?.items?.append(contentsOf: response?.items ?? [])
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        await loadTask?.value
    }
    
}
extension InbodyViewModel {
    
    @MainActor
    func refresh() async {
        skipCount = 0
        await getInbodyList()
    }

    @MainActor
    func loadMoreIfNeeded() async {
        guard !(isLoading ?? false),
              let currentCount = files?.items?.count,
              let totalCount = files?.totalCount,
              currentCount < totalCount,
              let maxResultCount = maxResultCount else { return }

        skipCount = (skipCount ?? 0) + maxResultCount
        await getInbodyList()
    }
    
    func clear() {
        files = nil
        skipCount = 0
        errorMessage = nil
        fileName = ""
        date = nil
        formattedDate = ""
        Comment = ""
        image = nil
        fileURL = nil
        showAddSheet = false
    }
}
//MARK: -- Functions --
//extension InbodyViewModel{
//    
//    func GetCustomerInbodyList(completion: @escaping (EventHandler?) -> Void) {
//        guard let maxResultCount = maxResultCount, let skipCount = skipCount else {
//            // Handle missing username or password
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount" : maxResultCount ,"skipCount" : skipCount]
//        completion(.loading)
//        // Create your API request with the username and password
//        let target = Authintications.GetCustomerInbody(parameters: parametersarr)
//
//        // Make the API call using your APIManager or networking code
//        BaseNetwork.callApi(target, BaseResponse<InbodyListM>.self) {[weak self] result in
//            // Handle the API response here
//            switch result {
//            case .success(let response):
//                // Handle the successful response
//                print("request successful: \(response)")
//
//                guard response.messageCode == 200 else {
//                    completion(.error(0, (response.message ?? "check validations")))
//                    return
//                }
//                
//                if self?.skipCount == 0 {
//                    self?.responseModel = response.data
//                } else {
//                    self?.responseModel?.items?.append(contentsOf: response.data?.items ?? [])
//                }
//                completion(.success)
//            case .failure(let error):
//                // Handle the error
//                print("Login failed: \(error.localizedDescription)")
//                completion(.error(0, "\(error.localizedDescription)"))
//            }
//
//        }
//    }
//    
//  
//    
//    func AddCustomerInbodyReport(fileType:FileType,progressHandler: @escaping (Double) -> Void,completion: @escaping (EventHandler?) -> Void) {
//        
//        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//          backgroundTask = UIApplication.shared.beginBackgroundTask {
//              UIApplication.shared.endBackgroundTask(backgroundTask)
//              backgroundTask = .invalid
//          }
//        
//        var  parametersarr: [String : Any] = [:]
//        switch fileType {
//        case .image:
//            guard let selfile = TestImage, let Date = Date else {
//                // Handle missing username or password
//                return
//            }
//             parametersarr  =  ["TestFile" : selfile ,"Date" : Date]
//
//        case .Pdf:
//            guard let selfile = TestPdf, let Date = Date else {
//                // Handle missing username or password
//                return
//            }
//             parametersarr =  ["TestFile" : selfile ,"Date" : Date]
//
//        }
//
//        completion(.loading)
//        // Create your API request with the username and password
//        let target = Authintications.CreateCustomerInboy(parameters: parametersarr)
//
//        DispatchQueue.global(qos: .background).async {
//            
//            // Make the API call using your APIManager or networking code
//            BaseNetwork.uploadApi(target, BaseResponse<InbodyListItemM>.self, progressHandler: { progress in
//                progressHandler(progress)
//            }) {[weak self] result in
//                // Handle the API response here
//                switch result {
//                case .success(let response):
//                    // Handle the successful response
//                    print("request successful: \(response)")
//                    
//                    guard response.messageCode == 200 else {
//                        completion(.error(0, (response.message ?? "check validations")))
//                        return
//                    }
//                    self?.addresponseModel = response.data
//                    
//                    completion(.success)
//                case .failure(let error):
//                    // Handle the error
//                    print("Login failed: \(error.localizedDescription)")
//                    completion(.error(0, "\(error.localizedDescription)"))
//                }
//                
//            }
//            
//        }
//        
//        
//        
//        
//        
//    }
//    
//}

