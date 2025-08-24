//
//  EditProfileViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 06/07/2025.
//

import Foundation
import UIKit

class EditProfileViewModel : ObservableObject {
    static let shared = EditProfileViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
//    Add file
    @Published var imageURL: String?
    @Published var Name: String = ""
    @Published var Gender: GenderM? = nil
    @Published var Country: AppCountryM? = nil
    @Published var Mobile: String = ""

    @Published var Image: UIImage?
//    @Published private var fileURL: URL?
        
    // Published properties
    @Published var profile : LoginM?
    
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
//        Task{
//            await getProfile()
//        }
    }
    func cleanup() {
//        imageURL = nil
//        Name = ""
        Gender = nil
        Country = nil
        Mobile = ""
        Image = nil
        profile = nil
        isLoading = false
        errorMessage = nil
        if !Helper.shared.CheckIfLoggedIn(){
                    imageURL = nil
                    Name = ""
        }
    }
}

//MARK: -- Functions --
extension EditProfileViewModel{
    
    @MainActor
    func updateProfile() async {
        isLoading = true
        defer { isLoading = false }
        guard let AppCountryId = Country?.id,let GenderId = Gender?.id else {
//            // Handle missings
//            self.errorMessage = "check inputs"
//            //            throw NetworkError.unknown(code: 0, error: "check inputs")
            return
        }
        
        let parametersarr : [String : Any] =  ["Name" : Name,"Mobile" : Mobile,"AppCountryId":AppCountryId,"GenderId" : GenderId]
        var parts: [MultipartFormDataPart] = parametersarr.map { key, value in
            MultipartFormDataPart(name: key, value: "\(value)")
        }
        
        if let image = Image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            parts.append(
                MultipartFormDataPart(name: "Image", filename: "profile.jpg", mimeType: "image/jpeg", data: imageData)
            )
        }
            let target = ProfileServices.UpdateProfile(parameters: parametersarr)

        do {
            self.errorMessage = nil
            let response = try await networkService.uploadMultipart(target, parts: parts, responseType: LoginM.self)
            self.profile = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getProfile() async {
        isLoading = true
        defer { isLoading = false }
//        guard let maxResultCount = maxResultCount,let skipCount = skipCount else {
////            // Handle missings
////            self.errorMessage = "check inputs"
////            //            throw NetworkError.unknown(code: 0, error: "check inputs")
//            return
//        }
//        let parametersarr : [String : Any] =  ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        let target = ProfileServices.GetProfile
        do {
            self.errorMessage = nil // Clear previous errors
            let response = try await networkService.request(
                target,
                responseType: LoginM.self
            )
            self.profile = response
            if let data = response{
                fillData(from: data)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fillData(from:LoginM) {
        imageURL = from.image ?? ""
        Name = from.name ?? ""
        Mobile = from.mobile ?? ""
//        Country = .init(id:from.appCountryId)
        Gender = GenderM(id: from.genderID,title: from.genderTitle)
    }
}

//extension MyFilesViewModel {
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
