//
//  DocEditProfileView.swift
//  Sehaty
//
//  Created by mohamed hammam on 09/09/2025.
//
import SwiftUI

struct DocEditProfileView: View {
    @EnvironmentObject private var viewModel: EditProfileViewModel
    //    @StateObject private var otpViewModel: OtpVM
    @StateObject private var lookupsVM = LookupsViewModel.shared
   
    @State private var bio: String = ""
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var selectedGender:GenderM? = nil
    @State private var selectedCountry:AppCountryM? = nil
    @State private var selectedSpeciality:SpecialityM? = nil

    // Image selection
//    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
//    @State private var selectedItem: PhotosPickerItem?
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage? = nil


    @State private var isPhoneValid: Bool = true
    //    @State private var isPasswordValid: Bool = true
    
    private var isNameValid: Bool{
        fullName.count == 0 || fullName.count > 3
    }
    @State var isEmailValid: Bool = true
//    {
////        email.count == 0 || email.count > 3
//        viewModel.isValidEmail(email)
////      return true
//    }
    private var isGenderValid: Bool{
        //        selectedGender != nil
        selectedGender == nil || selectedGender?.title?.count ?? 0 > 0
        
    }
    private var isCountryValid: Bool{
        //        selectedGender != nil
        selectedCountry == nil || selectedCountry?.name?.count ?? 0 > 0
        
    }
    private var isSpecialityValid: Bool{
        //        selectedGender != nil
        selectedSpeciality == nil || selectedSpeciality?.name?.count ?? 0 > 0
        
    }
    
//    init() {
//        _viewModel = StateObject(wrappedValue: DocEditProfileViewModel.shared)
//        //        _otpViewModel = StateObject(wrappedValue: OtpVM())
//    }
    
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - TitleBar
            TitleBar(title: "profile_editProfile".localized, hasbackBtn: true)
            
            // MARK: - Profile Image
            ScrollView{
            VStack {
                // Profile Image with Border and Edit Button
                ZStack(alignment: .bottomLeading) {
                    Group {
                        if let image = viewModel.Image {
                            Image(uiImage: image)
                                .resizable()
                            //                                .frame(width: 91, height: 91)
                            //                                .foregroundColor(.blue)
                            
                        }else{
                            KFImageLoader(url:URL(string:Constants.imagesURL + (viewModel.imageURL?.validateSlashs() ?? "")),placeholder: Image(.user), isOpenable: true,shouldRefetch: false)
                            
                            //                            Image(systemName: "person.circle.fill")
                            //                            .resizable()
                                .scaledToFill()
                                .frame(width: 91, height: 91)
                            //                            .foregroundColor(.blue)
                            
                        }
                    }
                    .clipShape(Circle())
                    .background(Circle()
                        .stroke(.white, lineWidth: 5).padding(-2))
                    .frame(width: 91,height:91)
                    .overlay(
                        Circle()
                            .stroke(Color.mainBlue, lineWidth: 1)
                            .padding(-5)
                    )
                    
                    // Edit Button
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image("editprofile")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(x: -5, y: -2)
                    }
                }
                .padding(.top,30)
                //                .padding(.bottom,50)
                
                Text(viewModel.Name)
                    .font(.bold(size: 24))
                    .foregroundStyle(Color(.main))
                    .padding(.bottom,50)
            }
            .padding(.top)
            
            // MARK: - Input Fields
            VStack(spacing: 25) {
//                if Helper.shared.getSelectedUserType() == .Doctor {
                    CustomInputFieldUI(
                        title: "Bio_title",
                        placeholder: "Bio_placeholder",
                        text: $bio,
                        isValid: true,
                        isMultilineText: true,
                        isIconOnTop: true,
                        trailingView: AnyView(
                            Image(.messagecentrepopup)
                                .resizable()
                                .frame(width: 18,height: 18)
                        )
                    )
//                }
                
                CustomInputFieldUI(
                    title: "signup_name_title",
                    placeholder: "signup_name_placeholder",
                    text: $fullName,
                    isValid: isNameValid,
                    trailingView: AnyView(
                        Image("signup_person")
                            .resizable()
                            .frame(width: 17,height: 20)
                    )
                )
                
                CustomInputFieldUI(
                    title: "login_mobile_title",
                    placeholder: "login_mobile_placeholder",
                    text: $phoneNumber,
                    isValid: isPhoneValid
                    ,trailingView: AnyView(
                        Menu {
                            ForEach(lookupsVM.appCountries ?? [],id: \.self) { country in
                                Button(action: {
                                    selectedCountry = country
                                }, label: {
                                    HStack{
                                        Text(country.name ?? "")
                                        
                                        KFImageLoader(url:URL(string:Constants.imagesURL + (country.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                            .frame(width: 30,height:17)
                                    }
                                })
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                
                                KFImageLoader(url:URL(string:Constants.imagesURL + (selectedCountry?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                    .frame(width: 30,height:17)
                                
                                //                                Text(selectedCountry?.flag ?? "")
                                //                                    .foregroundColor(.mainBlue)
                                //                                    .font(.medium(size: 22))
                            }
                        }
                    )
                )
                .keyboardType(.asciiCapableNumberPad)
                
//                if Helper.shared.getSelectedUserType() == .Doctor{
                    CustomInputFieldUI(
                        title: "signup_email_title",
                        placeholder: "signup_email_placeholder",
                        text: $email,
                        isValid: isEmailValid,
                        trailingView: AnyView(
                            Image("signup_person")
                                .resizable()
                                .frame(width: 17,height: 20)
                        )
                    )
//                }
                
                CustomInputFieldUI(
                    title: "signup_gender_title",
                    placeholder: "signup_gender_placeholder",
                    text: .constant(selectedGender?.title ?? ""),
                    isValid: isGenderValid,
                    isDisabled:true,
                    trailingView: AnyView(
                        Menu {
                            ForEach(lookupsVM.genders ?? [],id: \.self) { gender in
                                Button(gender.title ?? "", action: { selectedGender = gender })
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                
                                Image(.signupGender)
                                    .resizable()
                                    .frame(width: 19,height: 17)
                            }
                        }
                    )
                )
                
//                if Helper.shared.getSelectedUserType() == .Doctor{
                    CustomInputFieldUI(
                        title: "signup_country_title",
                        placeholder: "signup_country_placeholder",
                        text: .constant(selectedCountry?.name ?? ""),
                        isValid: isCountryValid,
                        isDisabled:true,
                        trailingView: AnyView(
                            Menu {
                                ForEach(lookupsVM.appCountries ?? [],id: \.self) { country in
                                    Button(country.name ?? "", action: { selectedCountry = country })
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                    
                                    Image(.signupGender)
                                        .resizable()
                                        .frame(width: 19,height: 17)
                                }
                            }
                        )
                    )
//                }
                
//                if Helper.shared.getSelectedUserType() == .Doctor{
                    CustomInputFieldUI(
                        title: "signup_speciality_title",
                        placeholder: "signup_speciality_placeholder",
                        text: .constant(selectedSpeciality?.name ?? ""),
                        isValid: isSpecialityValid,
                        isDisabled:true,
                        trailingView: AnyView(
                            Menu {
                                ForEach(lookupsVM.specialities ?? [],id: \.self) { speciality in
                                    Button(speciality.name ?? "", action: { selectedSpeciality = speciality })
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                    
                                    Image(.signupGender)
                                        .resizable()
                                        .frame(width: 19,height: 17)
                                }
                            }
                        )
                    )
//                }
                
            }
            .padding(.horizontal)
            
        }
            Spacer()

            // MARK: - Save Button
            CustomButtonUI(title: "save_".localized, isValid: true) {
//                saveProfile()
                Task{
                    viewModel.Bio = bio
                    viewModel.Name = fullName
                    viewModel.Mobile = phoneNumber
                    viewModel.Email = email
                    viewModel.Gender = selectedGender
                    viewModel.Country = selectedCountry
                    viewModel.Speciality = selectedSpeciality

//                    if viewModel.isDoctor{
//                    }
//                    viewModel.Image = image
                  await viewModel.updateProfile()
                }
            }
            .padding(.horizontal)
        }
//        .padding()
        .localizeView()
        .onAppear() {
            Task{
                async let countries:() = await lookupsVM.getAppCountries()
                async let genders:() = await lookupsVM.getGenders()
                async let specialities:() = await lookupsVM.getSpecialities()
                async let profil:() = await viewModel.getProfile()

                _ = await (countries,genders,specialities,profil)
                
                bio = viewModel.Bio
                fullName = viewModel.Name
                phoneNumber = viewModel.Mobile
                email = viewModel.Email
                
//                image =  viewModel.Image
//                selectedGender = viewModel.Gender
//                selectedCountry = viewModel.Country
                
                if let countries = lookupsVM.appCountries {
                    selectedCountry = countries.first(where: { $0.id == viewModel.DocProfile?.countryID ?? 0 }) ?? countries.first
                }
                if let genders = lookupsVM.genders {
                    selectedGender = genders.first(where: { $0.id == viewModel.DocProfile?.genderId ?? 0 }) ?? genders.first
                }
                if let specialities = lookupsVM.specialities {
                    selectedSpeciality = specialities.first(where: { $0.id == viewModel.DocProfile?.specialityID ?? 0 }) ?? specialities.first
                }
            }
        }
        .onDisappear() {
            viewModel.cleanup()
        }
        .onChange(of: phoneNumber) { newValue in
            // Remove non-digit characters (if needed)
            let filtered = newValue.filter { $0.isNumber }
            
            // Limit to 11 digits
            if filtered.count > 11 {
                phoneNumber = String(filtered.prefix(11))
            } else if filtered != newValue {
                phoneNumber = filtered
            }
            // Validate
            isPhoneValid = newValue.count == 0 || (phoneNumber.count == 11 && phoneNumber.starts(with: "01"))
        }
        .onChange(of: email) { newValue in
            isEmailValid = viewModel.isValidEmail(newValue)
        }
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $viewModel.Image , sourceType: imagePickerSource)
        }
    }

//    func saveProfile() {
//        
//        print("✅ الاسم: \(fullName)")
//        print("📞 رقم الموبايل: \(phoneNumber)")
//        print("👤 الجنس: \(selectedGender)")
////        if selectedImage != nil {
////            print("🖼️ تم اختيار صورة جديدة ✅")
////            // TODO: رفع الصورة للسيرفر
////        } else {
////            print("🖼️ لم يتم تغيير الصورة")
////        }
//    }
}

#Preview {
    DocEditProfileView().environmentObject(EditProfileViewModel.shared)
}
