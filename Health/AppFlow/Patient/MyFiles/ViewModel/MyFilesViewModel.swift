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
    @Published var files: [MyFileM] = []
    
    @Published var isLoading: Bool? = false
    @Published var errorMessage: String? = nil{didSet{errorMessage=nil}}

    // Serialize loads to avoid overlap
    private var loadTask: Task<Void, Never>? = nil
    
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
        
        // Validate required inputs
        let trimmedName = (fileName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            self.errorMessage = "please_enter_file_name".localized
            return
        }

        guard let FileTypeId = fileType?.id else {
            self.errorMessage = "please_select_file_type".localized
            return
        }

        // Require one of image, file URL, or link
        let hasImage = (image != nil)
        let hasFileURL = (fileURL != nil)
        let hasLink = !(fileLink ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if !(hasImage || hasFileURL || hasLink) {
            self.errorMessage = "please_select_image_file_or_link".localized
            return
        }

        let FileName = trimmedName
        
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
        
        do {
            self.errorMessage = nil
            _ = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
            Task{await getMyFilesList() }
            clearNewFiles()
        } catch {
            clearNewFiles()
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getMyFilesList() async {
        // Cancel any in-flight load to avoid overlap
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
            do {
                self.isLoading = true
                defer { self.isLoading = false }

                let target = MyFilesServices.GetFiles(parameters: [:])
                let response = try await self.networkService.request(target, responseType: [MyFileM].self)
                if let data = response {
                    await MainActor.run { self.files = data }
                }
            } catch is CancellationError {
                // Ignore cancellations; keep current state
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
        await loadTask?.value
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

    @MainActor
    func refresh() async {
        await getMyFilesList()
    }
}

