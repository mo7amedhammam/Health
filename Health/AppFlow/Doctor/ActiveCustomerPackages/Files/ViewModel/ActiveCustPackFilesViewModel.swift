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
    
//    Add file
    @Published private var fileName: String? = ""
    @Published private var fileType: FileTypeM? = nil
    @Published private var fileLink: String? = ""

    @Published private var image: UIImage?
    @Published private var fileURL: URL?
        
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
extension ActiveCustomerPackFilesViewModel{
    
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
        }
        
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
    func getCustomerFilesList() async {
        isLoading = true
        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyFilesServices.GetFiles
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
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = MyFilesServices.GetFiles
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
