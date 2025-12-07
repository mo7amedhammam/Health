//
//  LoginView.swift
//  Sehaty
//
//  Created by mohamed hammam on 08/09/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var isPhoneValid: Bool = true
    @State private var isPasswordValid: Bool = true
    
    @State private var selectedCountry: AppCountryM? = .init(id: 1, name: "Egypt", flag: "🇪🇬")

    @State private var isLoading: Bool? = false
    @State private var errorMessage: String? = nil
    
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var otpViewModel: OtpVM
    @StateObject private var lookupsVM = LookupsViewModel.shared

    @State private var destination = AnyView(EmptyView())
    @State private var isactive: Bool = false
    var skipToSignUp : Bool = false
    @State private var selectedUser: UserTypeEnum = Helper.shared.getSelectedUserType() ?? .Customer

    init( skipToSignUp : Bool = false) {
        self.skipToSignUp = skipToSignUp
        _loginViewModel = StateObject(wrappedValue: LoginViewModel())
        _otpViewModel = StateObject(wrappedValue: OtpVM())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 2) {
                ScrollView {
                    logoHeader
                    headerTexts
                    userTypeSelector
                    inputSection
                    Spacer(minLength: 0)
                    biometricButton
                }
                Spacer(minLength: 0)
                signInButton
                signupRowIfCustomer
                    .padding(.vertical)
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .onAppear(perform: onAppearFetchCountries)
            .onChange(of: phoneNumber, perform: validatePhone)
            .onChange(of: password, perform: validatePassword)
            .localizeView()
            .showHud(isShowing: $isLoading)
            .errorAlert(
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                ),
                message: errorMessage
            )
        }
        NavigationLink("", destination: destination, isActive: $isactive)
    }
}

// MARK: - Subviews (split to help type checker)
private extension LoginView {
    var logoHeader: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 132, height: 93)
            .padding(.bottom, 20)
            .padding(.top, 40)
    }
    
    var headerTexts: some View {
        CustomHeaderUI(title: "login_title".localized, subtitle: "login_subtitle".localized)
    }
    
    var userTypeSelector: some View {
        UserTypesList(selectedUser: $selectedUser) {
            Helper.shared.setSelectedUserType(userType: selectedUser)
            switch selectedUser {
            case .Customer: destination = AnyView(NewTabView())
            case .Doctor:   destination = AnyView(DocTabView())
            }
        }
    }
    
    var inputSection: some View {
        VStack(spacing: 30) {
            phoneField
            passwordFieldWithForgot
        }
        .padding(.top)
    }
    
    var phoneField: some View {
        CustomInputFieldUI(
            title: "login_mobile_title",
            placeholder: "login_mobile_placeholder",
            text: $phoneNumber,
            isValid: isPhoneValid,
            trailingView: AnyView(countryPickerMenu)
        )
        .keyboardType(.asciiCapableNumberPad)
    }
    
    var countryPickerMenu: some View {
        Menu {
            ForEach(lookupsVM.appCountries ?? [], id: \.self) { country in
                Button {
                    selectedCountry = country
                } label: {
                    HStack {
                        Text(country.name ?? "")
                        KFImageLoader(
                            url: URL(string: Constants.imagesURL + (country.flag?.validateSlashs() ?? "")),
                            placeholder: Image("egFlagIcon"),
                            shouldRefetch: true
                        )
                        .frame(width: 30, height: 17)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                
                KFImageLoader(
                    url: URL(string: Constants.imagesURL + (selectedCountry?.flag?.validateSlashs() ?? "")),
                    placeholder: Image("egFlagIcon"),
                    shouldRefetch: true
                )
                .frame(width: 30, height: 17)
            }
        }
    }
    
    var passwordFieldWithForgot: some View {
        VStack(alignment: .trailing, spacing: 12) {
            CustomInputFieldUI(
                title: "login_password_title",
                placeholder: "login_password_placeholder",
                text: $password,
                isSecure: true,
                showToggle: true,
                isValid: isPasswordValid
            )
            Button("login_forget_Password".localized) {
                sendOtp()
            }
            .font(.medium(size: 18))
            .foregroundColor(Color(.secondary))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var biometricButton: some View {
        BiometricLoginButton {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return
            }
            performLogin()
        }
    }
    
    var signInButton: some View {
        CustomButtonUI(title: "login_signin_btn", isValid: isFormValid) {
            login()
        }
    }
    
    var signupRowIfCustomer: some View {
        Group {
            if Helper.shared.getSelectedUserType() == .Customer {
                HStack {
                    Text("login_not_signin".localized)
                        .font(.medium(size: 18))
                        .foregroundColor(Color(.main))
                    Button("login_signup_btn".localized) {
                        pushTo(destination: SignUpView())
                    }
                    .font(.medium(size: 18))
                    .foregroundColor(Color(.secondary))
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Logic helpers
private extension LoginView {
    var isFormValid: Bool {
        (phoneNumber.count > 0 && isPhoneValid) && (password.count > 0 && isPasswordValid)
    }
    
    func onAppearFetchCountries() {
        if skipToSignUp{
            pushTo(destination: SignUpView())
        }
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            if selectedCountry == nil {
                selectedCountry = AppCountryM(id: 1, name: "Egypt", flag: "")
            }
            return
        }
        Task {
            async let countries: () = await lookupsVM.getAppCountries()
            _ = await (countries)
            if let countries = lookupsVM.appCountries {
                selectedCountry = countries.first(where: { $0.id == Helper.shared.AppCountryId() ?? 0 }) ?? countries.first
            }
        }
    }
    
    func validatePhone(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        if filtered.count > 11 {
            phoneNumber = String(filtered.prefix(11))
        } else if filtered != newValue {
            phoneNumber = filtered
        }
        isPhoneValid = newValue.isEmpty || (phoneNumber.count == 11 && phoneNumber.starts(with: "01"))
    }
    
    func validatePassword(_ newValue: String) {
        isPasswordValid = newValue.isEmpty || newValue.count >= 6
    }
    
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    func sendOtp() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "login_type_mobile_first".localized
            return
        }
        otpViewModel.mobile = phoneNumber
        otpViewModel.SendOtp { state in
            switch state {
            case .loading:
                isLoading = true
            case .stopLoading:
                isLoading = false
            case .success:
                isLoading = false
                DispatchQueue.main.async {
                    pushTo(destination: OTPView(
                        remainingSeconds: otpViewModel.responseModel?.secondsCount ?? 60,
                        otp: otpViewModel.responseModel?.otp ?? 00,
                        phone: phoneNumber,
                        verivyFor: .forgetPassword
                    ))
                }
            case .error(_, let error):
                isLoading = false
                errorMessage = error
            case .none, .some(.none):
                break
            }
        }
    }
    
    func login() {
        errorMessage = nil
        guard isFormValid else { return }
        loginViewModel.mobile = phoneNumber
        loginViewModel.password = password
        isLoading = true
        
        loginViewModel.login { result in
            isLoading = false
            switch result {
            case .success:
                Helper.shared.saveUser(user: loginViewModel.usermodel ?? LoginM())
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    return
                }
                DispatchQueue.main.async {
                    switch selectedUser {
                    case .Customer:
                        let newHome = UIHostingController(rootView: NewTabView())
                        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
                    case .Doctor:
                        let newHome = UIHostingController(rootView: DocTabView())
                        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func performLogin() {
        guard let phone = KeychainHelper.get("userPhone"),
              let password = KeychainHelper.get("userPassword") else {
            errorMessage = "Login_With_password_First".localized
            return
        }
        self.phoneNumber = phone
        self.password = password
        login()
    }
}

#Preview {
    LoginView()
}
