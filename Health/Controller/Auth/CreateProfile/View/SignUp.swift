//
//  SignUp.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

//import UIKit
//import DropDown

//enum DrobListSource{
//case Gender,District
//}
//class SignUp: UIViewController {
//
//    @IBOutlet weak var ContainerView: UIView!
//    @IBOutlet weak var TFName: CustomInputField!
//    @IBOutlet weak var TFPhone: CustomInputField!
//    @IBOutlet weak var TFPassword: CustomInputField!
//    @IBOutlet weak var TFPasswordConfirm: CustomInputField!
//    @IBOutlet weak var BtnRegister: UIButton!
//    @IBOutlet weak var STHaveAccount: UIStackView!
//    @IBOutlet weak var LaHaveAccount: UILabel!
//    @IBOutlet weak var BtnLogin: UIButton!
//
//    @IBOutlet weak var BtnBack: UIButton!
//    //    @IBOutlet weak var termsCheckboxButton: UIButton!
//    //    @IBOutlet weak var termsLabel: UILabel!
//
//    let ViewModel = SignUpVM()
//    //    private var isTermsAccepted = false {
//    //        didSet {
//    //            let imageName = isTermsAccepted ? "checkbox_checked" : "checkbox_unchecked"
//    //            termsCheckboxButton.setImage(UIImage(named: imageName), for: .normal)
//    //            validateForm()
//    //        }
//    //    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        refreshLocalization()
//        setupUI()
//        //        setupTerms()
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setupTextFieldsValidation() // Moved to viewDidAppear to ensure views are loaded
//    }
//    private func setupUI() {
//        BtnRegister.isEnabled(false)
//        BtnBack.setImage(UIImage(resource:  .backRight).flippedIfRTL, for: .normal)
//        hideKeyboardWhenTappedAround()
//    }
//
//    private func setupTextFieldsValidation() {
//        // Name validation - just required
//        TFName.validationRule = { text in
//            guard let text = text else { return false }
//            return !text.isEmpty
//        }
//
//        // Phone validation - starts with 01, 6-11 digits
//        TFPhone.textField.keyboardType = .phonePad
//        TFPhone.validationRule = { text in
//            guard let text = text else { return false }
//            return !text.isEmpty && text.count == 11 && text.starts(with: "01")
//        }
//
//        // Password validation - at least 6 characters
//        TFPassword.validationRule = { text in
//            guard let text = text else { return false }
//            return !text.isEmpty && text.count >= 6
//        }
//
//        // Password confirmation - must match password
//        TFPasswordConfirm.validationRule = { [weak self] text in
//            guard let self = self, let text = text else { return false }
//            return !text.isEmpty && text == self.TFPassword.textField.text
//        }
//
//        // Set up validation change handlers
//        [TFName, TFPhone, TFPassword, TFPasswordConfirm].forEach { field in
//            field?.onValidationChanged = { [weak self] isValid in
//                self?.validateForm()
//            }
//        }
//    }
//
//    //    private func setupTerms() {
//    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
//    //        termsLabel.isUserInteractionEnabled = true
//    //        termsLabel.addGestureRecognizer(tapGesture)
//    //        termsCheckboxButton.addTarget(self, action: #selector(termsCheckboxTapped), for: .touchUpInside)
//    //    }
//
//    @objc private func termsCheckboxTapped() {
//        //        isTermsAccepted.toggle()
//    }
//
//    @objc private func termsLabelTapped() {
//        //        let vc = TermsAndConditionsVC()
//        //        present(vc, animated: true)
//    }
//
//    private func validateForm() {
//        let isNameValid = TFName.textField.hasText && TFName.isValid
//        let isPhoneValid = TFPhone.textField.hasText && TFPhone.isValid
//        let isPasswordValid = TFPassword.textField.hasText && TFPassword.isValid
//        let isPasswordMatch = TFPasswordConfirm.textField.hasText && TFPasswordConfirm.isValid
//
//        BtnRegister.isEnabled(isNameValid && isPhoneValid && isPasswordValid && isPasswordMatch  )
//    }
//
//    private func refreshLocalization() {
//        //        let isRTL = Helper.shared.getLanguage() == "ar"
//        //        ContainerView.semanticContentAttribute = isRTL ? .forceLeftToRight : .forceRightToLeft
//        BtnRegister.setTitle("signup_signup_btn".localized, for: .normal)
//        LaHaveAccount.text = "signup_have_account".localized()
//        BtnLogin.setTitle("signup_signin_btn".localized, for: .normal)
//        //        termsLabel.text = "signup_accept_terms".localized()
//
//        //        STHaveAccount.semanticContentAttribute = isRTL ? .forceLeftToRight : .forceRightToLeft
//
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//    }
//
//    // MARK: - IBActions
//    @IBAction func BUBack(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func BULogin(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func BUSignUp(_ sender: Any) {
//        CreateAccount()
//    }
//
//    //    private func CreateAccount() {
//    //        ViewModel.name = TFName.textField.text
//    //        ViewModel.mobile = TFPhone.textField.text
//    //        ViewModel.password = TFPassword.textField.text
//    //
//    //        ViewModel.SignUp { [weak self] state in
//    //            guard let self = self, let state = state else { return }
//    //
//    //            switch state {
//    //            case .loading:
//    //                Hud.showHud(in: self.view)
//    //            case .stopLoading:
//    //                Hud.dismiss(from: self.view)
//    //            case .success:
//    //                Hud.dismiss(from: self.view)
//    //                self.GoToOTPVerification()
//    //            case .error(_, let error):
//    //                Hud.dismiss(from: self.view)
//    //                SimpleAlert.shared.showAlert(title: error ?? "", message: "", viewController: self)
//    //            case .none:
//    //                break
//    //            }
//    //        }
//    //    }
//
//
//    func CreateAccount(){
//        ViewModel.name = TFName.textField.text
//        ViewModel.mobile = TFPhone.textField.text
//        ViewModel.password = TFPassword.textField.text
//        Task {
//            do{
//                Hud.showHud(in: self.view)
//                try await ViewModel.CreateAccount()
//                // Handle success async operations
//                Hud.dismiss(from: self.view)
//                //                TVScreen.reloadData()
//                self.GoToOTPVerification()
//
//            }catch {
//                // Handle any errors that occur during the async operations
//                print("Error: \(error)")
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
//            }
//        }
//    }
//
//    private func GoToOTPVerification() {
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
//        vc.Phonenumber = TFPhone.textField.text
//        vc.otp = ViewModel.responseModel?.otp ?? 0
//        vc.second =  ViewModel.responseModel?.secondsCount ?? 60
//        Shared.shared.remainingSeconds = ViewModel.responseModel?.secondsCount ?? 60
//        vc.verivyFor = .CreateAccount
//        navigationController?.pushViewController(vc, animated: true)
//
//        //        if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
//        //            viewDone.title = "تم إرسال طلب انضمامك بنجاح"
//        //            viewDone.imgStr = "keyicon"
//        //            viewDone.action = {
//        //                viewDone.removeFromSuperview()
//        //                Helper.shared.changeRootVC(newroot: LoginVC.self, transitionFrom: .fromLeft)
//        //            }
//        //        }
//    }
//}

//MARK: ---- functions -----
//extension SignUp{
//
//    //    func textFieldDidBeginEditing(_ textField: UITextField) {
//    //
//    //        if textField == TFPhone {
//    //            TFPhone.textField.textColor = UIColor(named: "main")
//    //            ViewPhoneNum.borderColor = UIColor(named: "stroke")
//    //        } else if textField == TFName {
//    //            ViewName.borderColor = UIColor(named: "stroke")
//    //            TFName.textField.textColor = UIColor(named: "main")
//    ////        } else if textField == TFCode {
//    ////            ViewCode.borderColor = UIColor(named: "stroke")
//    ////            TFCode.textColor = UIColor(named: "main")
//    //        }else if textField == TFPassword{
//    //            ViewPassword.borderColor = UIColor(named: "stroke")
//    //        }else if textField == TFPasswordConfirm{
//    //            ViewPasswordConfirm.borderColor = UIColor(named: "stroke")
//    //        }else{
//    //        }
//    //    }
//
//    //    func textFieldDidEndEditing(_ textField: UITextField) {
//    //
//    //        if textField == TFPhone {
//    //            if TFPhone.textField.text?.count == 0 {
//    //                BtnPhone.isHidden = true
//    //            } else {
//    //                BtnPhone.isHidden = false
//    //            }
//    //
//    //        } else  if textField == TFName {
//    //            if TFName.textField.text?.count == 0 {
//    //                BtnName.isHidden = true
//    //            } else {
//    //                BtnName.isHidden = false
//    //            }
//    //
//    //        } else  if textField == TFPassword {
//    //            if TFPassword.textField.text?.count == 0 {
//    //                BtnPassword.isHidden = true
//    //            } else {
//    //                BtnPassword.isHidden = false
//    //            }
//    //        } else if textField == TFPasswordConfirm{
//    //            if TFPasswordConfirm.textField.text?.count == 0 {
//    //                BtnPasswordConfirm.isHidden = true
//    //            } else {
//    //                BtnPasswordConfirm.isHidden = false
//    //            }
//    //        }
//    //
//    //    }
//
//    //    @objc func textFieldDidChange(_ textField: UITextField) {
//    //        let isPhoneValid = TFPhone.textField.text?.count == 11 // Check if TFPhone has 11 digits
//    //        let isNameValid = TFName.textField.hasText // Check if TFPassword is not empty
//    //        let isPasswordValid = DistrictId != nil
//    //        let isPasswordConfirmValid = GenderId != nil
//    //
//    //        let isValidForm = isPhoneValid && isNameValid && isPasswordValid && isPasswordConfirmValid
//    //        BtnRegister.isEnabled(isValidForm)
//    //    }
//
//    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    //        if textField == TFPhone {
//    //            // Calculate the new length of the text after applying the replacement string
//    //            let currentText = textField.text ?? ""
//    //            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//    //
//    //            // Check if the new length exceeds the allowed limit (11 digits)
//    //            if newText.count > 11 {
//    //                return false
//    //            }
//    //        }
//    //        return true
//    //    }
//
//
//
//
////    func getDistricts(){
////        ViewModel.GetDistricts{ [weak self] state in
////            guard let self = self else{return}
////            guard let state = state else{
////                return
////            }
////            self.getGenders()
////
////            switch state {
////            case .loading:
////                Hud.showHud(in: self.view)
////            case .stopLoading:
//////                Hud.dismiss(from: self.view)
////                print("")
////            case .success:
//////                Hud.dismiss(from: self.view)
////                print(state)
////            case .error(_,let error):
//////                Hud.dismiss(from: self.view)
////                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
////                print(error ?? "")
////            case .none:
////                print("")
////            }
////        }
////    }
////    func getGenders(){
////        ViewModel.GetGenders{ [weak self]state in
////            guard let self = self, let state = state else{
////                return
////            }
////
////            switch state {
////            case .loading:
//////                Hud.showHud(in: self.view)
////                print("")
////            case .stopLoading:
////                Hud.dismiss(from: self.view)
////            case .success:
////                Hud.dismiss(from: self.view)
////                print(state)
////            case .error(_,let error):
////                Hud.dismiss(from: self.view)
////                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
////                print(error ?? "")
////            case .none:
////                print("")
////            }
////        }
////    }
//
//    //========================
//
////    func SetDropDown(DropListSource: String ){
////        switch DropListSource {
////
////        case "Gender":
////            if let dataArray = ViewModel.GendersArr{
////                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
////            }
////            rightBarDropDown.anchorView = TFPassword
////            let preferredViewWidth = TFPassword.frame.size.width // Assuming ViewPreferred is a UIView
////            rightBarDropDown.width = preferredViewWidth
////            ViewPasswordConfirm.borderColor = UIColor(named: "stroke")
////            TFPasswordConfirm.textColor = UIColor(named: "main")
////            //            ViewGender.backgroundColor = .white
////            BtnPasswordConfirm.isSelected = true
////
////        case "District":
////            if let dataArray = ViewModel.DistrictsArr{
////                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
////            }
////            rightBarDropDown.anchorView = TFDistrict
////            let preferredViewWidth = TFDistrict.frame.size.width // Assuming ViewPreferred is a UIView
////            rightBarDropDown.width = preferredViewWidth
////            ViewDistrict.borderColor = UIColor(named: "stroke")
////            TFDistrict.textColor = UIColor(named: "main")
////            //            ViewDistrict.backgroundColor = .white
////            BtnDistrict.isSelected = true
////
////        default:
////            print("")
////        }
////
////        rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)
////        rightBarDropDown.show()
////
////
////
////        rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
////            print("Selected item: \(item) at index: \(index)")
////            switch DropListSource {
////            case "Gender":
////                self.TFGender.text = ViewModel.GendersArr?[index].title
////                self.GenderId = ViewModel.GendersArr?[index].id
////                BtnGender.isSelected = false
////
////                let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
////                let isNameValid = TFName.hasText // Check if TFPassword is not empty
//////                let isCodeValid = TFCode.hasText // Check if TFCode is not empty
////                let isDestrictValid = DistrictId != nil
////                let isGenderValid = GenderId != nil
////
////                let isValidForm = isPhoneValid && isNameValid && isDestrictValid && isGenderValid
////                BtnRegister.enable(isValidForm)
////
////            case "District":
////                self.TFDistrict.text = ViewModel.DistrictsArr?[index].title
////                self.DistrictId = ViewModel.DistrictsArr?[index].id
////                BtnDistrict.isSelected = false
////
////
////                let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
////                let isNameValid = TFName.hasText // Check if TFPassword is not empty
//////                let isCodeValid = TFCode.hasText // Check if TFCode is not empty
////                let isDestrictValid = DistrictId != nil
////                let isGenderValid = GenderId != nil
////
////                let isValidForm = isPhoneValid && isNameValid && isDestrictValid && isGenderValid
////                BtnRegister.enable(isValidForm)
////
////            default:
////                print("")
////            }
////        }
////    }
//
//
//}

import SwiftUI

struct SignUpView: View {
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedCountry:AppCountryM? = .init(id: 1, name: "Egypt", flag: "🇪🇬")
    @State private var selectedGender:GenderM? = nil
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    
    @State private var isPhoneValid: Bool = true
    //    @State private var isPasswordValid: Bool = true
    
    private var isNameValid: Bool{
        fullName.count == 0 || fullName.count > 3
    }
    
    private var isCountryValid: Bool{
        selectedCountry == nil || selectedCountry?.name?.count ?? 0 > 0
    }
    private var isGenderValid: Bool{
        //        selectedGender != nil
        selectedGender == nil || selectedGender?.title?.count ?? 0 > 0
        
    }
    private var isPasswordValid: Bool{
        password.count == 0 || password.count >= 6
    }
    private var isConfirmPasswordValid: Bool{
        (confirmPassword.count == 0  || (confirmPassword.count >= 6 && confirmPassword == password))
    }
    
    @State private var countries: [AppCountryM] = [
        AppCountryM(id: 1, name: "Egypt", flag: "🇪🇬"),
        AppCountryM(id: 2, name: "Saudi Arabia", flag: "🇸🇦"),
        AppCountryM(id: 3, name: "Phalastine", flag: "🇦🇪")
    ]
    @State private var genders: [GenderM] = [
        .init(id: 1, title: "Male"),
        .init(id: 2, title: "Female")
    ]
    @State private var isLoading:Bool? = false
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss
    
    
    @StateObject private var viewModel: SignUpVM
    //    @StateObject private var otpViewModel: OtpVM
    @StateObject private var lookupsVM = LookupsViewModel.shared
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: SignUpVM())
        //        _otpViewModel = StateObject(wrappedValue: OtpVM())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            TitleBar(title: "",hasbackBtn: true)
            
            CustomHeaderUI(title: "Signup_title".localized, subtitle: "Signup_subtitle".localized)
                .padding(.top,30)
                .padding(.bottom,15)
            
            VStack(spacing: 30){
                
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
                    title: "signup_mobile_title",
                    placeholder: "signup_mobile_placeholder",
                    text: $phoneNumber,
                    isValid: isPhoneValid,
                    trailingView: AnyView(
                        Menu {
                            ForEach(lookupsVM.appCountries ?? countries,id: \.self) { country in
                                
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
                .task {
                    await lookupsVM.getAppCountries()
                }
                
                CustomInputFieldUI(
                    title: "signup_gender_title",
                    placeholder: "signup_gender_placeholder",
                    text: .constant(selectedGender?.title ?? ""),
                    isValid: isGenderValid,
                    trailingView: AnyView(
                        Menu {
                            ForEach(lookupsVM.genders ?? genders,id: \.self) { gender in
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
                .task {
                    await lookupsVM.getGenders()
                }
                
                Group{
                    CustomInputFieldUI(
                        title: "signup_password_title",
                        placeholder: "signup_password_placeholder",
                        text: $password,
                        isSecure: true,
                        showToggle: true,
                        isValid: isPasswordValid
                    )
                    
                    CustomInputFieldUI(
                        title: "signup_confirmpassword_title",
                        placeholder: "signup_confirmpassword_placeholder",
                        text: $confirmPassword,
                        isSecure: true,
                        showToggle: true,
                        isValid: isConfirmPasswordValid
                    )
                }
                
                
            }
            .padding(.top)
            
            Spacer()
            
            
            CustomButtonUI(title: "signup_signup_btn",isValid: isFormValid){
                //                login()
                CreateAccount()
            }
            
            HStack {
                Text("signup_have_account".localized)
                    .font(.medium(size: 18))
                    .foregroundColor(Color(.main))
                
                Button("signup_signin_btn".localized) {
                    // Navigate to register
                    login()
                }
                .font(.medium(size: 18))
                .foregroundColor(Color(.secondary))
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .padding(.horizontal)
        .environment(\.layoutDirection, .rightToLeft)
        //        .onChange(of: phoneNumber) { newValue in
        //            // Keep only digits
        //            let filtered = newValue.filter { $0.isNumber }
        //
        //            // Limit to 11 characters
        //            if filtered.count > 11 {
        //                phoneNumber = String(filtered.prefix(11))
        //            } else {
        //                phoneNumber = filtered
        //            }
        //        }
        
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
        
        //        .onChange(of: password) { newValue in
        //            isPasswordValid = newValue.count == 0 || newValue.count >= 6
        //        }
        .showHud(isShowing:  $isLoading)
        .alert(item: $viewModel.errorMessage) { msg in
            Alert(title: Text("_خطأ".localized), message: Text(msg.localized), dismissButton: .default(Text("OK_".localized)))
        }
        
    }
    
}

#Preview {
    SignUpView()
}

extension SignUpView {
    
    private var isFormValid: Bool {
        (fullName.count > 0 && isNameValid)
        && (phoneNumber.count > 0 && isPhoneValid)
        && (selectedCountry != nil && isCountryValid)
        && (selectedGender != nil && isGenderValid)
        && (password.count > 0 && isPasswordValid)
        && (confirmPassword.count > 0 && isConfirmPasswordValid)
    }
    
    private func CreateAccount() {
        guard isFormValid else { return }
        
        viewModel.name = fullName
        
        viewModel.countryId = selectedCountry?.id ?? nil
        viewModel.mobile = phoneNumber
        viewModel.genderId = selectedGender?.id ?? nil
        
        viewModel.password = password
        isLoading = true
        
        //        viewModel.login { result in
        //            isLoading = false
        //            switch result {
        //            case .success:
        //                Helper.shared.saveUser(user: loginViewModel.usermodel ?? LoginM())
        //                DispatchQueue.main.async {
        //                    let newHome = UIHostingController(rootView: NewTabView())
        //                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
        //                }
        //            case .failure(let error):
        //                errorMessage = error.localizedDescription
        //            }
        //        }
        
        viewModel.createAccount {
            // ✅ Navigate to OTP Screen
            if let otp = viewModel.responseModel?.otp,
               let seconds = viewModel.responseModel?.secondsCount {
                isLoading = false
                showOtpVC(phone: viewModel.mobile, otp: otp, seconds: seconds)
            }
        }
    }
    
    func login() {
        DispatchQueue.main.async {
            //            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else { return }
            //            pushUIKitVC(vc)
            dismiss()
        }
        
    }
    
    private func showOtpVC(phone: String, otp: Int, seconds: Int) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else { return }
        vc.Phonenumber = phone
        vc.otp = otp
        vc.second = seconds
        vc.verivyFor = .CreateAccount
//        Shared.shared.remainingSeconds = seconds
        pushUIKitVC(vc)
    }
    
}
