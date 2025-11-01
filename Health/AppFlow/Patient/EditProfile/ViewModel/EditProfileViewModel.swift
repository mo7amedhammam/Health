//
//  EditProfileViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 06/07/2025.
//

import Foundation
import UIKit

//protocol BaseProfile {
//    var image: String? { get }
//    var name: String? { get }
//    var mobile: String? { get }
//    var genderID: Int? { get }
//    var genderTitle: String? { get }
//}
//
//extension CustProfileM: BaseProfile {}
//extension DocProfileM: BaseProfile {
//    var image: String? {
//        return self.imagePath
//    }
//    
//    var genderID: Int? {
//        return nil
//    }
//    
//    var genderTitle: String? {
//        return nil
//    }
//}

class EditProfileViewModel : ObservableObject {
    static let shared = EditProfileViewModel()
    // Injected service
    private let networkService: AsyncAwaitNetworkServiceProtocol
    
    // Add file
    @Published var imageURL: String?
    @Published var Name: String = ""
    @Published var Bio: String = ""
    @Published var Email: String = ""

    @Published var Gender: GenderM? = nil
    @Published var Country: AppCountryM? = nil
    @Published var Speciality: GenderM? = nil

    @Published var Mobile: String = ""

    @Published var Image: UIImage?
        
    // Published properties
    @Published var profile : CustProfileM?
    @Published var DocProfile : DocProfileM?

    // UI state
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil

    // Per-field validation errors
    @Published var nameError: String? = nil
    @Published var mobileError: String? = nil
    @Published var genderError: String? = nil
    @Published var countryError: String? = nil

    var isDoctor: Bool {
        return Helper.shared.getSelectedUserType() == .Doctor
    }
    // Computed: enable/disable Save button
    var canSubmit: Bool {
        // Run validation without setting error strings (dry run)
        return validateInputs(applyErrors: false)
    }
    
    // Init with DI
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }

    func cleanup() {
        Gender = nil
        Country = nil
        Mobile = ""
        Image = nil
        Bio = ""
        profile = nil
        DocProfile = nil
        isLoading = false
        errorMessage = nil
        nameError = nil
        mobileError = nil
        genderError = nil
        countryError = nil
        Speciality = nil
        if !Helper.shared.CheckIfLoggedIn(){
            imageURL = nil
            Name = ""
        }
    }

    // MARK: - Validation

    // Mirrors SignUpView mobile rule: 11 digits, starts with "01"
    private func isValidMobile(_ value: String) -> Bool {
        let digitsOnly = value.filter { $0.isNumber }
        return digitsOnly.count == 11 && digitsOnly.hasPrefix("01")
    }

    // Validate all inputs. If applyErrors is true, set per-field error strings for UI.
    @discardableResult
    private func validateInputs(applyErrors: Bool = true) -> Bool {
        var valid = true

        // Name required: min 2 characters after trimming
        let trimmedName = Name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameIsValid = trimmedName.count >= 2
        if applyErrors { nameError = nameIsValid ? nil : "Please enter a valid name (min 2 characters)" }
        valid = valid && nameIsValid

        // Mobile required: 11 digits starting with 01
        let mobileIsValid = isValidMobile(Mobile)
        if applyErrors { mobileError = mobileIsValid ? nil : "Please enter a valid mobile number (11 digits starting with 01)" }
        valid = valid && mobileIsValid

        // Gender required
        let genderIsValid = (Gender?.id != nil)
        if applyErrors { genderError = genderIsValid ? nil : "Please select gender" }
        valid = valid && genderIsValid

        // Country required
        let countryIsValid = (Country?.id != nil)
        if applyErrors { countryError = countryIsValid ? nil : "Please select country" }
        valid = valid && countryIsValid

        // Image optional — no validation
        if applyErrors {
            // If any field invalid, also surface a top-level message (optional)
            errorMessage = valid ? nil : "Please complete all required fields correctly."
        }

        return valid
    }
}

//MARK: -- Functions --
extension EditProfileViewModel{
    
    @MainActor
    func updateProfile() async {
        // Validate required data first
        guard validateInputs(applyErrors: true) else { return }

        isLoading = true
        defer { isLoading = false }

        guard let appCountryId = Country?.id,
              let genderId = Gender?.id else {
            // Defensive: should be covered by validation above
            errorMessage = "Please select country and gender."
            return
        }
        var parametersarr : [String : Any] =  [
            "Name" : Name.trimmingCharacters(in: .whitespacesAndNewlines),
            "Mobile" : Mobile.filter { $0.isNumber },
            "AppCountryId": appCountryId,
            "GenderId" : genderId
        ]
        
        if isDoctor{
            if Email.count > 0{
            parametersarr["email"] = Email
        }else{
            errorMessage = "Please type email."
            return
        }
            
            if let Speciality = Speciality{
            parametersarr["SpecialityId"] = Speciality.id
        }else{
            errorMessage = "Please select speciality."
            return
        }
        }
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
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
                
                let response = try await networkService.uploadMultipart(target, parts: parts, responseType: CustProfileM.self)
                self.profile = response
                
            case .Doctor:
                let response = try await networkService.uploadMultipart(target, parts: parts, responseType: DocProfileM.self)
                self.DocProfile = response
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        let target = ProfileServices.GetProfile
        do {
            self.errorMessage = nil // Clear previous errors
            
            switch Helper.shared.getSelectedUserType() {
            case .Customer,.none:
            let response = try await networkService.request(
                target,
                responseType: CustProfileM.self
            )
            self.profile = response
            if let data = response{
                fillData(from: data)
            }
            
                
            case .Doctor:
                let response = try await networkService.request(
                    target,
                    responseType: DocProfileM.self
                )
                self.DocProfile = response
                if let data = response{
                    fillData(from: data)
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fillData(from profile: CustProfileM) {
        Image = nil
        imageURL = profile.image ?? ""
        Name = profile.name ?? ""
        Mobile = profile.mobile ?? ""
        // Country not fully reconstructable without lookup; keep as-is.
        Gender = GenderM(id: profile.genderID, title: profile.genderTitle)

        // Clear previous validation errors when filling from server
        nameError = nil
        mobileError = nil
        genderError = nil
        countryError = nil
    }
    func fillData(from profile: DocProfileM) {
        Image = nil
        imageURL = profile.imagePath ?? ""
        Name = profile.name ?? ""
        Mobile = profile.mobile ?? ""
        // Country not fully reconstructable without lookup; keep as-is.
        Gender = GenderM(id: profile.genderId, title: profile.genderTitle)
        Country = AppCountryM(id: profile.countryID, name: profile.countryTitle)
        Speciality = GenderM(id: profile.specialityID, title: profile.speciality)

        // Clear previous validation errors when filling from server
        nameError = nil
        mobileError = nil
        genderError = nil
        countryError = nil
    }
}
