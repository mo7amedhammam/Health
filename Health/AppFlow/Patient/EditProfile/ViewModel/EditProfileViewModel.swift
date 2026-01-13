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
    private var loadTask: Task<Void,Never>? = nil
    
    // Add file
    @Published var imageURL: String?
    @Published var Name: String = ""
    @Published var Bio: String = ""
    @Published var Email: String = ""
    
    @Published var Gender: GenderM? = nil
    @Published var Country: AppCountryM? = nil
    @Published var Speciality: SpecialityM? = nil
    
    @Published var Mobile: String = ""
    
    @Published var Image: UIImage?
    
    // Published properties
    @Published var profile : CustProfileM?
    @Published var DocProfile : DocProfileM?
    
    // UI state
    @Published var isUpdated:Bool? = false
    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    // Per-field validation errors
    //    @Published var BioError: String? = nil
    //    @Published var nameError: String? = nil
    //    @Published var emailError: String? = nil
    //    @Published var mobileError: String? = nil
    //    @Published var genderError: String? = nil
    //    @Published var countryError: String? = nil
    //    @Published var specialityError: String? = nil
    
    var isDoctor: Bool {
        return Helper.shared.getSelectedUserType() == .Doctor
    }
    // Computed: enable/disable Save button
    var canSubmit: Bool {
        // Run validation without setting error strings (dry run)
        return validateInputs()
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
        //        errorMessage = nil
        //        nameError = nil
        //        mobileError = nil
        //        genderError = nil
        //        countryError = nil
        Speciality = nil
        if !Helper.shared.CheckIfLoggedIn(){
            imageURL = nil
            Name = ""
        }
    }
    
    // MARK: - Validation
    
    // Mirrors SignUpView mobile rule: 11 digits, starts with "01"
    func isValidMobile(_ value: String) -> Bool {
        let digitsOnly = value.filter { $0.isNumber }
        return digitsOnly.count == 11 && digitsOnly.hasPrefix("01")
    }
    
    // Mirrors SignUpView mobile rule: 11 digits, starts with "01"
    func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // More forgiving and reliable email pattern
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: trimmed)
    }
    
    // Validate all inputs. If applyErrors is true, set per-field error strings for UI.
    //    @discardableResult
    
    private func validateInputs() -> Bool {
        var valid = true
        
        // Name required: min 2 characters after trimming
        let trimmedName = Name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameIsValid = trimmedName.isEmpty == false
        guard nameIsValid else {
            errorMessage = nameIsValid ? nil : "Please_enter_a_valid_name_(min_2_characters)".localized
            return false }
        valid = valid && nameIsValid
        
        // Mobile required: 11 digits starting with 01
        let mobileIsValid = isValidMobile(Mobile)
        guard mobileIsValid else {
            errorMessage = mobileIsValid ? nil : "Please_enter_a_valid_mobile_number_(11_digits_starting_with_01)".localized
            return false
        }
        valid = valid && mobileIsValid
        
        // Gender required
        let genderIsValid = (Gender?.id != nil)
        guard genderIsValid else{
            errorMessage = genderIsValid ? nil : "Please_select_gender".localized
            return false
        }
        valid = valid && genderIsValid
        
        if isDoctor{
            // email required
            let emailIsValid = isValidEmail(Email)
            guard emailIsValid else {
                errorMessage = emailIsValid ? nil : "Please_enter_a_valid_email".localized
                return false
            }
            valid = valid && emailIsValid
            
            // Country required
            let countryIsValid = (Country?.id != nil)
            guard countryIsValid else{
                errorMessage = countryIsValid ? nil : "Please_select_country".localized
                return false
            }
            valid = valid && countryIsValid
            
            // speciality required
            let SpecialityIsValid = (Speciality?.id != nil)
            guard SpecialityIsValid else{
                errorMessage = SpecialityIsValid ? nil : "Please_select_speciality".localized
                return false
            }
            valid = valid && SpecialityIsValid
        }
        
        // Image optional — no validation
        //        if applyErrors {
        // If any field invalid, also surface a top-level message (optional)
        //            errorMessage = valid ? nil : errorMessage
        //        }
        
        return valid
        
    }
}

//MARK: -- Functions --
extension EditProfileViewModel{
    
    @MainActor
    func updateProfile() async {
        // Validate required data first
        guard validateInputs() else { return }
        
        isLoading = true
//        isUpdated = false
        defer { isLoading = false }
        
        guard let appCountryId = Country?.id,
              let genderId = Gender?.id else {
            // Defensive: should be covered by validation above
            //            errorMessage = "make_Sure_you_selected_country_and_gender.".localized
            return
        }
        var parametersarr : [String : Any] =  [
            "Name" : Name.trimmingCharacters(in: .whitespacesAndNewlines),
            "Mobile" : Mobile.filter { $0.isNumber },
            "AppCountryId": appCountryId,
            "GenderId" : genderId
        ]
        
        if isDoctor{
            //            if Bio.count > 0{
            parametersarr["bio"] = Bio
            //        }
            
            //            if Email.count > 0{
            parametersarr["email"] = Email
            //        }
            //            else{
            //            errorMessage = "Please_type_email.".localized
            //            return
            //        }
            
            if let Speciality = Speciality{
                parametersarr["SpecialityId"] = Speciality.id
            }
            //            else{
            //            errorMessage = "Please_select_speciality.".localized
            //            return
            //        }
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
            isUpdated = true
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
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            if self.isLoading == true { return }
            
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
        await loadTask?.value
    }
    
    func fillData(from profile: CustProfileM) {
        Image = nil
        imageURL = profile.image ?? ""
        Name = profile.name ?? ""
        Mobile = profile.mobile ?? ""
        // Country not fully reconstructable without lookup; keep as-is.
        Gender = GenderM(id: profile.genderID, title: profile.genderTitle)
        // Clear previous validation errors when filling from server
        errorMessage = nil
        //        nameError = nil
        //        mobileError = nil
        //        genderError = nil
        //        countryError = nil
    }
    func fillData(from profile: DocProfileM) {
        Image = nil
        imageURL = profile.imagePath ?? ""
        Bio = profile.bio ?? ""
        Name = profile.name ?? ""
        Mobile = profile.mobile ?? ""
        Email = profile.email ?? ""
        // Country not fully reconstructable without lookup; keep as-is.
        Gender = GenderM(id: profile.genderId, title: profile.genderTitle)
        Country = AppCountryM(id: profile.countryID, name: profile.countryTitle)
        Speciality = SpecialityM(id: profile.specialityID, name: profile.speciality)
        
        // Clear previous validation errors when filling from server
        //        BioError = nil
        errorMessage = nil
        //        nameError = nil
        //        emailError = nil
        //        mobileError = nil
        //        genderError = nil
        //        countryError = nil
        //        specialityError = nil
    }
}
