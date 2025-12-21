//
//  MyFilesViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 25/06/2025.
//

import Foundation
import UIKit

class MyFilesViewModel : ObservableObject {
    static let shared = MyFilesViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
//    Add file
    @Published var fileName: String? = ""
    @Published var fileType: FileTypeM? = nil
    @Published var fileLink: String? = ""

    @Published var image: UIImage?
    @Published var fileURL: URL?
    @Published var showUploadSheet:Bool = false

    // Published properties
    @Published var files : [MyFileM]? 
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

//MARK: -- Functions --
extension MyFilesViewModel{
    
    @MainActor
    func addNewFile() async {
        isLoading = true
        defer { isLoading = false }
        guard let FileName = fileName ,let FileTypeId = fileType?.id else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        var parametersarr : [String : Any] =  ["FileName":FileName,"FileTypeId":FileTypeId]
        
        let target = MyFilesServices.AddFile(parameters: parametersarr)
        
        if let image = image {
            let data = image.imageWithColor(color1: .blue).imageWithColor(color1: .blue)
            parametersarr["FilePath"] = data
        }else if let fileURL = fileURL {
            parametersarr["FilePath"] = fileURL
        }else if let filelink = fileLink {
            parametersarr["Url"] = filelink
        }
        
//        let parametersarr : [String : Any] =  ["Name" : Name,"Mobile" : Mobile,"AppCountryId":AppCountryId,"GenderId" : GenderId]
        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
            MultipartFormDataPart(name: key, value: "\(value)")
        }
        
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            parts.append(
                MultipartFormDataPart(name: "FilePath", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
            )
        }
        else if let fileURL = fileURL {
            do {
                let fileData = try Data(contentsOf: fileURL)
                let fileName = fileURL.lastPathComponent
                let mimeType = "application/pdf"

                parts.append(
                    MultipartFormDataPart(
                        name: "FilePath",
                        filename: fileName,
                        mimeType: mimeType,
                        data: fileData
                    )
                )
            } catch {
                print("Failed to read file: \(error)")
            }
        }
        
//        if let fileURL = fileURL,
//           let imageData = image.jpegData(compressionQuality: 0.8) {
//            parts.append(
//                MultipartFormDataPart(name: "FilePath", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
//            )
//        }
        
//            let target = ProfileServices.UpdateProfile(parameters: parametersarr)

        do {
            self.errorMessage = nil
            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
            Task{await getMyFilesList() }
            clearNewFiles()
        } catch {
            clearNewFiles()
            self.errorMessage = error.localizedDescription
        }
//        do {
//            self.errorMessage = nil // Clear previous errors
//            let response = try await networkService.request(
//                target,
//                responseType: [MyFileM].self
//            )
////            self.files = response
//            Task{await getMyFilesList() }
//            clearNewFiles()
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
    }
    
    @MainActor
    func getMyFilesList() async {
        isLoading = true
        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyFilesServices.GetFiles(parameters: [:])
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
    
    
}

extension MyFilesViewModel {
    func clearNewFiles() {
        fileName = nil
        fileType = nil
        fileLink = nil
        image = nil
        fileURL = nil
        showUploadSheet = false
    }
//
    @MainActor
    func refresh() async {
//        skipCount = 0
        self.files?.removeAll()
        await getMyFilesList()
    }
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
}
