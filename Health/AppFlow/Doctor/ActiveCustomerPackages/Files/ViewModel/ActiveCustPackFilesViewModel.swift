//
//  MyFilesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 17/09/2025.
//


import Foundation
import UIKit

class ActiveCustomerPackFilesViewModel : ObservableObject {
    static let shared = ActiveCustomerPackFilesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    var customerPackageId:Int?
    var doctorId:Int?
    var CustomerId:Int?
//    Add file
    @Published var fileName: String? = ""
    @Published var fileType: FileTypeM? = nil
    @Published var fileLink: String? = ""
    @Published var notes : String?

    @Published var image: UIImage?
    @Published var fileURL: URL?
        
    // Published properties
    @Published var files : [MyFileM]?
    
    @Published var showUploadSheet:Bool = false

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension ActiveCustomerPackFilesViewModel{
    
//    @MainActor
//    func addNewFile() async {
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
//        }
//        
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
    
    @MainActor
    func addNewPackageFile() async {
        isLoading = true
        defer { isLoading = false }
        guard let customerPackageId = customerPackageId,let doctorId = doctorId ,let FileName = fileName ,let FileTypeId = fileType?.id else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        var parametersarr : [String : Any] =  ["customerPackageId":customerPackageId,"doctorId":doctorId,"fileName":FileName,"fileTypeId":FileTypeId]
        
        let target = DocActivePackagesServices.CreateCustomerPackageInstructionByCPId(parameters: parametersarr)
        
        if let image = image {
            let data = image.imageWithColor(color1: .blue).imageWithColor(color1: .blue)
            parametersarr["filePath"] = data
        }else if let fileURL = fileURL {
            parametersarr["filePath"] = fileURL
        }
        if let notes = notes {
            parametersarr["notes"] = notes
        }
        
//        let parametersarr : [String : Any] =  ["Name" : Name,"Mobile" : Mobile,"AppCountryId":AppCountryId,"GenderId" : GenderId]
        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
            MultipartFormDataPart(name: key, value: "\(value)")
        }
        
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            parts.append(
                MultipartFormDataPart(name: "filePath", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
            )
        }
        else if let fileURL = fileURL {
            do {
                let fileData = try Data(contentsOf: fileURL)
                let fileName = fileURL.lastPathComponent
                let mimeType = "application/pdf"

                parts.append(
                    MultipartFormDataPart(
                        name: "filePath",
                        filename: fileName,
                        mimeType: mimeType,
                        data: fileData
                    )
                )
            } catch {
                print("Failed to read file: \(error)")
            }
        }
        do {
            self.errorMessage = nil
            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
            Task{await getPackageFilesList() }
            clearNewFiles()
        } catch {
            clearNewFiles()
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getCustomerFilesList() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerId = CustomerId else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["CustomerId":CustomerId]
        
        let target = MyFilesServices.GetFiles(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [MyFileM].self
            )
            self.files = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    @MainActor
    func getPackageFilesList() async {
        isLoading = true
        defer { isLoading = false }
        guard let CustomerPackageId = customerPackageId else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        let parametersarr : [String : Any] =  ["CustomerPackageId":CustomerPackageId]
        
        let target = DocActivePackagesServices.GetCustomerPackageInstructionByCPId(parameters: parametersarr)
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: [MyFileM].self
            )
            self.files = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    func clearNewFiles() {
        fileName = nil
        fileType = nil
        fileLink = nil
        image = nil
        fileURL = nil
        showUploadSheet = false
    }
}
