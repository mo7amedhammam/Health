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
    
//    @State private var countries: [AppCountryM] = [
//        AppCountryM(id: 1, name: "Egypt", flag: "🇪🇬"),
//        AppCountryM(id: 2, name: "Saudi Arabia", flag: "🇸🇦"),
//        AppCountryM(id: 3, name: "Phalastine", flag: "🇦🇪")
//    ]
    @State private var selectedCountry:AppCountryM? = .init(id: 1, name: "Egypt", flag: "🇪🇬")

    @State private var isLoading:Bool? = false
    @State private var errorMessage: String? = nil
    
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var otpViewModel: OtpVM
    @StateObject private var lookupsVM = LookupsViewModel.shared

    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    @State var selectedUser : UserTypeEnum = Helper.shared.getSelectedUserType() ?? .Customer

    init() {
        _loginViewModel = StateObject(wrappedValue: LoginViewModel())
        _otpViewModel = StateObject(wrappedValue: OtpVM())
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                
                ScrollView{
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132,height: 93)
                        .padding(.bottom,20)
                        .padding(.top,40)
                    
                    CustomHeaderUI(title: "login_title".localized, subtitle: "login_subtitle".localized)

                    UserTypesList(selectedUser: $selectedUser){
                        Helper.shared.setSelectedUserType(userType:selectedUser)
                        
                        switch selectedUser {
                        case .Customer:
                            destination = AnyView(NewTabView())
                            
                        case .Doctor:
                            destination = AnyView(DocTabView())
                        }
                    }
                    
                    
                    VStack(spacing: 30){
                        
                        CustomInputFieldUI(
                            title: "login_mobile_title",
                            placeholder: "login_mobile_placeholder",
                            text: $phoneNumber,
                            isValid: isPhoneValid,
                            trailingView: AnyView(
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
                        
                        VStack(alignment: .trailing, spacing: 12) {
                            CustomInputFieldUI(
                                title: "login_password_title",
                                placeholder: "login_password_placeholder",
                                text: $password,
                                isSecure: true,
                                showToggle: true,
                                isValid:  isPasswordValid
                            )
                            
                            Button("login_forget_Password".localized) {
                                // Handle forgot password
                                sendOtp()
                            }
                            .font(.medium(size: 18))
                            .foregroundColor(Color(.secondary))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                    //                Image(.touchidicon)
                    //                    .resizable()
                    //                    .frame(width: 68, height: 68)
                    //                    .foregroundColor(.pink)
                    //                    .padding(.top, 8)
                    
                    BiometricLoginButton {
                        // تسجيل الدخول بعد نجاح التحقق
                        performLogin()
                    }
                }
                Spacer()
                
                CustomButtonUI(title: "login_signin_btn",isValid: isFormValid){
                    print("---->>  ",selectedUser.user)
                    login()
                }
                
                if Helper.shared.getSelectedUserType() == .Customer{
                HStack {
                    Text("login_not_signin".localized)
                        .font(.medium(size: 18))
                        .foregroundColor(Color(.main))
                    
                    Button("login_signup_btn".localized) {
                        // Navigate to register
                        //                        signup()
                        pushTo(destination: SignUpView())
                        
                    }
                    .font(.medium(size: 18))
                    .foregroundColor(Color(.secondary))
                }
                .padding(.top, 4)
            }
                
                Spacer()
            }
            .padding(.horizontal)
            .onAppear(){
                Task{
                    async let countries:() = await lookupsVM.getAppCountries()
                    _ = await (countries)
                    if let countries = lookupsVM.appCountries {
                        selectedCountry = countries.first(where: { $0.id == Helper.shared.AppCountryId() ?? 0 }) ?? countries.first
                    }
                }
            }
            //        .environment(\.layoutDirection, .rightToLeft)
            
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
            .onChange(of: password) { newValue in
                isPasswordValid = newValue.count == 0 || newValue.count >= 6
            }
            .localizeView()
            .showHud(isShowing:  $isLoading)
            .errorAlert(isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            ), message: errorMessage)
            
//                    .alert(item: $errorMessage) { msg in
//                        Alert(title: Text("_خطأ".localized), message: Text(msg.localized), dismissButton: .default(Text("OK_".localized)))
//                    }
            
        }
        NavigationLink( "", destination: destination, isActive: $isactive)
    

    }
    
    private var isFormValid: Bool {
        (phoneNumber.count > 0 && isPhoneValid) && (password.count > 0 && isPasswordValid)
    }
    
    private func sendOtp() {
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
                // Navigate to OTP screen if needed
                //                   pushTo(destination: OtpVC.self as! (any View))
                DispatchQueue.main.async {
                    
                    
                    pushTo(destination: OTPView(remainingSeconds :otpViewModel.responseModel?.secondsCount ?? 60, otp:otpViewModel.responseModel?.otp ?? 00, phone: phoneNumber,verivyFor:.forgetPassword))
//                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else { return }
//                    vc.Phonenumber = phoneNumber
//                    vc.second = otpViewModel.responseModel?.secondsCount ?? 60
//                    vc.otp = otpViewModel.responseModel?.otp ?? 00
//                    //                                 Shared.shared.remainingSeconds = otpViewModel.responseModel?.secondsCount ?? 60
//                    vc.verivyFor = .forgetPassword
                    
//                    pushUIKitVC(vc)
                }
                
                //                   print("OTP Sent")
            case .error(_, let error):
                isLoading = false
                errorMessage = error
            case .none:
                break
            case .some(.none):
                break
                
            }
        }
    }
    
    private func login() {
        errorMessage = nil
        guard isFormValid else { return }
        //           loginViewModel.appCountryId = 1
        loginViewModel.mobile = phoneNumber
        loginViewModel.password = password
        isLoading = true
        
        loginViewModel.login { result in
            isLoading = false
            switch result {
            case .success:
                Helper.shared.saveUser(user: loginViewModel.usermodel ?? LoginM())
                DispatchQueue.main.async {
                    switch selectedUser {
                    case .Customer:
//                        destination = AnyView(NewTabView())
                        let newHome = UIHostingController(rootView: NewTabView())
                        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)

                    case .Doctor:
//                        destination = AnyView(DocTabView())
                        let newHome = UIHostingController(rootView: DocTabView())
                        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)

                    }
//                    let newHome = UIHostingController(rootView: destination)
//                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
    
//    func signup() {
//        DispatchQueue.main.async {
////            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else { return }
////            pushUIKitVC(vc)
//            
//            pushTo(destination: SignUpView())
//        }
//        
//    }
    
    func performLogin(){
        guard let phone = KeychainHelper.get("userPhone"),
              let password = KeychainHelper.get("userPassword") else {
            errorMessage = "Login_With_password_First".localized
            print("❌ No credentials saved.")
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
