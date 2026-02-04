////
////  MyFilesViewModel.swift
////  Sehaty
////
////  Created by mohamed hammam on 17/09/2025.
////
//
//
import Foundation
import UIKit
//
//class ActiveCustomerPackFilesViewModel : ObservableObject {
//    static let shared = ActiveCustomerPackFilesViewModel()
//    // Injected service
//    private let networkService: AsyncAwaitNetworkServiceProtocol
//    
//    var customerPackageId:Int?
//    var doctorId:Int?
//    var CustomerId:Int?
////    Add file
//    @Published var fileName: String? = ""
//    @Published var fileType: FileTypeM? = nil
//    @Published var fileLink: String? = ""
//    @Published var notes : String?
//
//    @Published var image: UIImage?
//    @Published var fileURL: URL?
//        
//    // Published properties
//    @Published var files : [MyFileM]?
//    
//    @Published var showUploadSheet:Bool = false
//
//    @Published var isLoading:Bool? = false
//    @Published var errorMessage: String? = nil
//    
//    // Init with DI
//    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
//        self.networkService = networkService
//    }
//}
//
////MARK: -- Functions --
//extension ActiveCustomerPackFilesViewModel{
//    
////    @MainActor
////    func addNewFile() async {
////        isLoading = true
////        defer { isLoading = false }
////        guard let FileName = fileName ,let FileTypeId = fileType?.id else {
//////            // Handle missings
//////            self.errorMessage = "check inputs"
//////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
////            return
////        }
////        var parametersarr : [String : Any] =  ["FileName":FileName,"FileTypeId":FileTypeId]
////        
////        let target = MyFilesServices.AddFile(parameters: parametersarr)
////        
////        if let image = image {
////            let data = image.imageWithColor(color1: .blue).imageWithColor(color1: .blue)
////            parametersarr["FilePath"] = data
////        }else if let fileURL = fileURL {
////            parametersarr["FilePath"] = fileURL
////        }
////        
////        do {
////            self.errorMessage = nil // Clear previous errors
////            let response = try await networkService.request(
////                target,
////                responseType: [MyFileM].self
////            )
////            self.files = response
////        } catch {
////            self.errorMessage = error.localizedDescription
////        }
////    }
//  
//    @MainActor
//    func addNewCustomerFile() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let FileName = fileName ,let FileTypeId = fileType?.id else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        var parametersarr : [String : Any] =  ["FileName":FileName,"FileTypeId":FileTypeId]
//        
//        let target = MyFilesServices.AddFile(parameters: parametersarr)
//        
//        if let image = image {
//            let data = image.imageWithColor(color1: .blue).imageWithColor(color1: .blue)
//            parametersarr["FilePath"] = data
//        }else if let fileURL = fileURL {
//            parametersarr["FilePath"] = fileURL
//        }else if let filelink = fileLink {
//            parametersarr["Url"] = filelink
//        }
//        
////        let parametersarr : [String : Any] =  ["Name" : Name,"Mobile" : Mobile,"AppCountryId":AppCountryId,"GenderId" : GenderId]
//        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
//            MultipartFormDataPart(name: key, value: "\(value)")
//        }
//        
//        if let image = image,
//           let imageData = image.jpegData(compressionQuality: 0.8) {
//            parts.append(
//                MultipartFormDataPart(name: "FilePath", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
//            )
//        }
//        else if let fileURL = fileURL {
//            do {
//                let fileData = try Data(contentsOf: fileURL)
//                let fileName = fileURL.lastPathComponent
//                let mimeType = "application/pdf"
//
//                parts.append(
//                    MultipartFormDataPart(
//                        name: "FilePath",
//                        filename: fileName,
//                        mimeType: mimeType,
//                        data: fileData
//                    )
//                )
//            } catch {
//                print("Failed to read file: \(error)")
//            }
//        }
//        do {
//            self.errorMessage = nil
//            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
//            Task{await getCustomerFilesList() }
//            clearNewFiles()
//        } catch {
//            clearNewFiles()
//            self.errorMessage = error.localizedDescription
//        }
//    }
//    
//    @MainActor
//    func addNewPackageFile() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let customerPackageId = customerPackageId,let doctorId = doctorId ,let FileName = fileName ,let FileTypeId = fileType?.id else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        var parametersarr : [String : Any] =  ["customerPackageId":customerPackageId,"doctorId":doctorId,"fileName":FileName,"fileTypeId":FileTypeId]
//        
//        let target = DocActivePackagesServices.CreateCustomerPackageInstructionByCPId(parameters: parametersarr)
//        
//        if let image = image {
//            let data = image.imageWithColor(color1: .blue).imageWithColor(color1: .blue)
//            parametersarr["filePath"] = data
//        }else if let fileURL = fileURL {
//            parametersarr["filePath"] = fileURL
//        }
//        if let notes = notes {
//            parametersarr["notes"] = notes
//        }
//        
////        let parametersarr : [String : Any] =  ["Name" : Name,"Mobile" : Mobile,"AppCountryId":AppCountryId,"GenderId" : GenderId]
//        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
//            MultipartFormDataPart(name: key, value: "\(value)")
//        }
//        
//        if let image = image,
//           let imageData = image.jpegData(compressionQuality: 0.8) {
//            parts.append(
//                MultipartFormDataPart(name: "FilePath", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
//            )
//        }
//        else if let fileURL = fileURL {
//            do {
//                let fileData = try Data(contentsOf: fileURL)
//                let fileName = fileURL.lastPathComponent
//                let mimeType = "application/pdf"
//
//                parts.append(
//                    MultipartFormDataPart(
//                        name: "FilePath",
//                        filename: fileName,
//                        mimeType: mimeType,
//                        data: fileData
//                    )
//                )
//            } catch {
//                print("Failed to read file: \(error)")
//            }
//        }
//        do {
//            self.errorMessage = nil
//            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
//            Task{await getPackageFilesList() }
//            clearNewFiles()
//        } catch {
//            clearNewFiles()
//            self.errorMessage = error.localizedDescription
//        }
//    }
//    
//    @MainActor
//    func getCustomerFilesList() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let CustomerId = CustomerId else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["CustomerId":CustomerId]
//        
//        let target = MyFilesServices.GetFiles(parameters: parametersarr)
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
//    }
//    @MainActor
//    func getPackageFilesList() async {
//        isLoading = true
//        defer { isLoading = false }
//        guard let CustomerPackageId = customerPackageId else {
//////            // Handle missings
//////            self.errorMessage = "check inputs"
//////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
//        
//        let target = DocActivePackagesServices.GetCustomerPackageInstructionByCPId(parameters: parametersarr)
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
//    }
//    
//    
//    func clearNewFiles() {
//        fileName = nil
//        fileType = nil
//        fileLink = nil
//        image = nil
//        fileURL = nil
//        showUploadSheet = false
//    }
//}


struct UploadFileRequest {
    let fileName: String
    let fileTypeId: Int
    let link: String?
    let notes: String?

    let fileData: Data?
    let fileNameOnDisk: String?
    let mimeType: String?

    let customerId: Int?
    let doctorId: Int?
    let customerPackageId: Int?

    var isImage: Bool {
        fileMimeType?.contains("image") ?? false
    }
    // fix for 'fileMimeType' not found: expose a computed property
      var fileMimeType: String? {
          return mimeType
      }
}
struct UploadedFile {
    let id: Int
    let name: String
    let url: String
}
protocol FilesRepositoryProtocol {
    func uploadFile(_ request: UploadFileRequest) async throws
    func getCustomerFiles(customerId: Int) async throws -> [MyFileM]
    func getPackageFiles(packageId: Int) async throws -> [MyFileM]
}
final class FilesRepository: FilesRepositoryProtocol {
    private let network: AsyncAwaitNetworkServiceProtocol

    init(network: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.network = network
    }

    func uploadFile(_ request: UploadFileRequest) async throws {
        var params: [String: Any] = [
            "FileName": request.fileName,
            "FileTypeId": request.fileTypeId
        ]
        
        if let link = request.link { params["Url"] = link }
        if let notes = request.notes { params["Notes"] = notes }
        //        if let customerId = request.customerId { params["CustomerId"] = customerId }
        //        if let doctorId = request.doctorId {
//        params["DoctorId"] = 10
//    }
        if let packageId = request.customerPackageId { params["CustomerPackageId"] = packageId }
print("params",params)
        let target: TargetType1 =
//            request.customerPackageId != nil ?
        DocActivePackagesServices.CreateCustomerPackageInstructionByCPId(parameters: params)
//            : MyFilesServices.AddFile(parameters: params)

        var parts: [MultipartFormDataPart] = params.map {
            MultipartFormDataPart(name: $0.key, value: "\($0.value)")
        }

        if let data = request.fileData,
           let name = request.fileNameOnDisk,
           let mime = request.mimeType {
            parts.append(MultipartFormDataPart(
                name: "FilePath",
                filename: name,
                mimeType: mime,
                data: data
            ))
        }

        _ = try await network.uploadMultipart(target, parts: parts, responseType: LoginM.self)
    }

    func getCustomerFiles(customerId: Int) async throws -> [MyFileM] {
        let params = ["CustomerId": customerId]
        let target = MyFilesServices.GetFiles(parameters: params)
        return try await network.request(target, responseType: [MyFileM].self) ?? []
    }

    func getPackageFiles(packageId: Int) async throws -> [MyFileM] {
        let params = ["CustomerPackageId": packageId]
        let target = DocActivePackagesServices.GetCustomerPackageInstructionByCPId(parameters: params)
        return try await network.request(target, responseType: [MyFileM].self) ?? []
    }
}
protocol UploadFileUseCaseProtocol {
    func execute(_ request: UploadFileRequest) async throws
}

struct UploadFileUseCase: UploadFileUseCaseProtocol {
    let repo: FilesRepositoryProtocol

    func execute(_ request: UploadFileRequest) async throws {
        try await repo.uploadFile(request)
    }
}
protocol FetchFilesUseCaseProtocol {
    func fetchCustomerFiles(id: Int) async throws -> [MyFileM]
    func fetchPackageFiles(id: Int) async throws -> [MyFileM]
}

struct FetchFilesUseCase: FetchFilesUseCaseProtocol {
    let repo: FilesRepositoryProtocol

    func fetchCustomerFiles(id: Int) async throws -> [MyFileM] {
        try await repo.getCustomerFiles(customerId: id)
    }

    func fetchPackageFiles(id: Int) async throws -> [MyFileM] {
        try await repo.getPackageFiles(packageId: id)
    }
}
@MainActor
final class ActiveCustomerPackFilesViewModel: ObservableObject {

    @Published var files: [MyFileM]? = []
    @Published var showUploadSheet = false{didSet{errorMessage=nil}}
    @Published var isLoading : Bool? = false
    @Published var errorMessage: String?

    // File input state
    @Published var fileName: String? = ""
    @Published var fileType: FileTypeM?
    @Published var fileLink: String?
    @Published var image: UIImage?
    @Published var fileURL: URL?
    @Published var notes: String?

    var customerPackageId: Int?
    var doctorId: Int?
    var customerId: Int?

    // Use cases
    private let uploadUseCase: UploadFileUseCaseProtocol
    private let fetchUseCase: FetchFilesUseCaseProtocol
    private var loadTask: Task<Void,Never>? = nil

    init(
        uploadUseCase: UploadFileUseCaseProtocol = UploadFileUseCase(repo: FilesRepository()),
        fetchUseCase: FetchFilesUseCaseProtocol = FetchFilesUseCase(repo: FilesRepository())
    ) {
        self.uploadUseCase = uploadUseCase
        self.fetchUseCase = fetchUseCase
    }

    func addNewPackageFile() async {
        guard let fileType = fileType else { return }

        let data = await extractFileData()

        let request = UploadFileRequest(
            fileName: fileName ?? "",
            fileTypeId: fileType.id ?? 0,
            link: fileLink,
            notes: notes,
            fileData: data.fileData,
            fileNameOnDisk: data.fileName,
            mimeType: data.mimeType,
            customerId: customerId,
            doctorId: doctorId,
            customerPackageId: customerPackageId
        )

        isLoading = true
        do {
            try await uploadUseCase.execute(request)
            clearForm()
            showUploadSheet = false
            await refreshFiles(forcase: .Packages)
        } catch {
            showUploadSheet = false
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func refreshFiles(forcase : filesCases) async {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            isLoading = true
            defer { isLoading = false }
            
            do {
                switch forcase {
                case .Customer:
                    guard let customerId else { return }
                    files = try await fetchUseCase.fetchCustomerFiles(id: customerId)
                    
                case .Packages:
                    guard let customerPackageId else { return }
                    files = try await fetchUseCase.fetchPackageFiles(id:customerPackageId )
                    
                }
                //            if let cid = customerId {
                //                files = try await fetchUseCase.fetchCustomerFiles(id: cid)
                //                return
                //            }
                //            if let pid = customerPackageId {
                //                files = try await fetchUseCase.fetchPackageFiles(id: pid)
                //                return
                //            }
                //            files = []
            } catch {
                errorMessage = error.localizedDescription
                files = []
            }
        }
        await loadTask?.value
    }

    private func extractFileData() async -> (fileData: Data?, fileName: String?, mimeType: String?) {
        if let image = image {
            return (image.jpegData(compressionQuality: 0.9), "image.jpg", "image/jpeg")
        }
        if let url = fileURL {
            return (try? Data(contentsOf: url), url.lastPathComponent, "application/pdf")
        }
        return (nil, nil, nil)
    }

    func clearForm() {
        isLoading = nil
        fileName = ""
        fileType = nil
        fileLink = nil
        image = nil
        fileURL = nil
        notes = nil
    }
}



////UNIT TEST
//import XCTest
//@testable import YourAppModule
//
//final class UploadFileUseCaseTests: XCTestCase {
//    class FakeRepo: FilesRepositoryProtocol {
//        var uploadCalled = false
//        func uploadFile(_ request: UploadFileRequest) async throws {
//            uploadCalled = true
//            // optionally throw or return
//        }
//        func getCustomerFiles(customerId: Int) async throws -> [MyFileM] { [] }
//        func getPackageFiles(packageId: Int) async throws -> [MyFileM] { [] }
//    }
//
//    func testUploadSuccess() async {
//        let repo = FakeRepo()
//        let useCase = UploadFileUseCase(repo: repo)
//        let req = UploadFileRequest(fileName: "t", fileTypeId: 1, link: nil, notes: nil,
//                                    fileData: nil, fileNameOnDisk: nil, mimeType: nil,
//                                    customerId: 1, doctorId: nil, customerPackageId: nil)
//
//        do {
//            try await useCase.execute(req)
//            XCTAssertTrue(repo.uploadCalled)
//        } catch {
//            XCTFail("unexpected error: \(error)")
//        }
//    }
//}
//
//final class FetchFilesUseCaseTests: XCTestCase {
//    class FakeRepo: FilesRepositoryProtocol {
//        var returnedFiles: [MyFileM] = []
//        func uploadFile(_ request: UploadFileRequest) async throws {}
//        func getCustomerFiles(customerId: Int) async throws -> [MyFileM] { returnedFiles }
//        func getPackageFiles(packageId: Int) async throws -> [MyFileM] { returnedFiles }
//    }
//
//    func testFetchCustomerFiles() async {
//        let repo = FakeRepo()
//        repo.returnedFiles = [MyFileM(id: 1, fileName: "a", filePath: "x")]
//        let useCase = FetchFilesUseCase(repo: repo)
//        do {
//            let files = try await useCase.fetchCustomerFiles(id: 1)
//            XCTAssertEqual(files.count, 1)
//        } catch {
//            XCTFail("unexpected error: \(error)")
//        }
//    }
//}
//final class ServiceLocator {
//    static let shared = ServiceLocator()
//
//    private var registry: [String: Any] = [:]
//
//    func register<T>(_ service: T, for type: T.Type) {
//        let key = String(describing: type)
//        registry[key] = service
//    }
//
//    func resolve<T>(_ type: T.Type) -> T? {
//        let key = String(describing: type)
//        return registry[key] as? T
//    }
//}
