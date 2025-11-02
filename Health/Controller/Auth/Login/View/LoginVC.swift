//
//  CustomTextField.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/04/2025.
//

import UIKit
import SwiftUI

//final class LoginVC: UIViewController {
//
//    @IBOutlet weak var HeaderView: CustomHeader!
//    @IBOutlet weak var TFMobile: CustomInputField!
//    @IBOutlet weak var TFPassword: CustomInputField!
//
//    @IBOutlet weak var BtnForgetPassword: UIButton!
//    @IBOutlet private weak var BtnLogin: UIButton!
//
//    @IBOutlet weak var STDontHaveAccount: UIStackView!
//    @IBOutlet weak var LaDontHaveAccount: UILabel!
//
//    @IBOutlet weak var BtnCreateAccount: UIButton!
//    private var isMobileValid = false
//    private var isPasswordValid = false
//
//    private let validationTooltip = UILabel()
//
//    private var viewModel: LoginViewModelProtocol
//    let otpViewModel = OtpVM()
//
//    init(viewModel: LoginViewModelProtocol = LoginViewModel()) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        self.viewModel = LoginViewModel()
//        super.init(coder: coder)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        refreshLocalization()
//        setupUI()
////        setupBindings()
//        setupValidation()
//        refreshLocalization()
//    }
//
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
//////        refreshLocalization()
////    }
//
////    override func viewWillLayoutSubviews() {
////        super.viewWillLayoutSubviews()
////        refreshLocalization()
////        setupUI()
////    }
//
//    private func setupUI() {
//        BtnForgetPassword.underlineCurrentTitle()
//        BtnLogin.isEnabled(false)
//        hideKeyboardWhenTappedAround()
//    }
//    private func refreshLocalization() {
////        let isRTL = Helper.shared.getLanguage() == "ar"
//           // Refresh all localizable elements
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[self] in
//            HeaderView.titleKey = "login_title"
//            HeaderView.subtitleKey = "login_subtitle"
//
//            TFMobile.titleKey = "login_mobile_title"
//            TFMobile.placeholderKey = "login_mobile_placeholder"
//
//            TFPassword.titleKey = "login_password_title"
//            TFPassword.placeholderKey = "login_password_placeholder"
//
//            BtnForgetPassword.localized(key: "login_forget_Password")
//            BtnLogin.localized(key: "login_signin_btn")
//            LaDontHaveAccount.text = "login_not_signin".localized
//            BtnCreateAccount.localized(key: "login_signup_btn")
//
//            view.setNeedsLayout()
//            view.layoutIfNeeded()
//        })
//       }
////    override func viewDidLayoutSubviews() {
////        super.viewDidLayoutSubviews()
////        refreshLocalization()
////    }
//
//    private func setupValidation() {
//         // Mobile Validation
//         TFMobile.validationRule = {  text in
//             guard let text = text else { return false }
//             let isValid = text.count == 11 && text.starts(with: "01")
//             return isValid
//         }
//        TFMobile.onValidationChanged = { [weak self] isValid in
//            self?.isMobileValid = isValid
//            self?.updateLoginButtonState()
//        }
//
//        // Example of advanced password validation
//        TFPassword.validationRule = {text in
//            guard let text = text else { return false }
//            // At least 6 characters, with 1 uppercase, 1 digit
////            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*\\d).{6,}$")
////            return passwordTest.evaluate(with: text)
//
//            let isValid = text.count >= 6
//            return isValid
//        }
//
//          TFPassword.onValidationChanged = { [weak self] isValid in
//              self?.isPasswordValid = isValid
//              self?.updateLoginButtonState()
//          }
//
//          // Trigger initial validation
////          TFMobile.validateField()
////          TFPassword.validateField()
//      }
//    @objc private func mobileFieldDidChange() {
//         // Enforce 11 character limit
//        if let text = TFMobile.textField.text, text.count > 11 {
//             TFMobile.textField.text = (String(text.prefix(11)))
//         }
////         TFMobile.validateField()
//     }
//
//    private func updateLoginButtonState() {
//            BtnLogin.isEnabled(isMobileValid && isPasswordValid)
//
//            // Optional: Change button appearance based on state
////            BtnLogin.alpha = (isMobileValid && isPasswordValid) ? 1.0 : 0.6
//        }
//
//        @IBAction func BUForgetPassword(_ sender: Any) {
//            if TFMobile.textField.text != ""{
//                SendOtp()
//            } else {
//                SimpleAlert.shared.showAlert(title: "اكتب رقم موبايل الأول", message: "", viewController: self){
////                    [weak self] in
////                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
////                    vc.Phonenumber = TFMobile.textField.text
////                    vc.second =  otpViewModel.responseModel?.secondsCount ?? 60
////                    vc.otp = otpViewModel.responseModel?.otp ?? 00
////                    Shared.shared.remainingSeconds = otpViewModel.responseModel?.secondsCount ?? 60
////                    vc.verivyFor = .forgetPassword
////                    navigationController?.pushViewController(vc, animated: true)
//                }
//                return
//            }
//        }
//    @IBAction private func BULogin(_ sender: Any) {
//        login()
//    }
//        @IBAction func BUSignUp(_ sender: Any) {
//            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else{return}
//            navigationController?.pushViewController(vc, animated: true)
//        }
//
//    private func login() {
//        viewModel.mobile = TFMobile.textField.text
//        viewModel.password = TFPassword.textField.text
//
//        DispatchQueue.main.async {
//            ActivityIndicatorView.shared.startLoading(in: self.view)
//        }
//
////            Task {
////                do{
////                    Hud.showHud(in: self.view)
////                    try await viewModel.login()
////                    // Handle success async operations
////                    Hud.dismiss(from: self.view)
////    //                TVScreen.reloadData()
////                    Helper.shared.saveUser(user: self.viewModel.usermodel ?? LoginM())
////                    Helper.shared.changeRootVC(newroot: HTBC.self, transitionFrom: .fromLeft)
////
////                }catch {
////                    // Handle any errors that occur during the async operations
////                    print("Error: \(error)")
////                    Hud.dismiss(from: self.view)
////                    SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
////                }
////            }
//
//
//        viewModel.login { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
////                    NewHud.dismiss(from: self.view)
//                    ActivityIndicatorView.shared.stopLoading()
//
//                    Helper.shared.saveUser(user: self.viewModel.usermodel ?? LoginM())
////                    Helper.shared.changeRootVC(newroot: HTBC.self, transitionFrom: .fromLeft)
//
//                    let newHome = UIHostingController(rootView: NewTabView())
////                    let nav = UINavigationController(rootViewController: vc)
//
//                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
//                }
//            case .failure(let error):
//                print(error)
//                DispatchQueue.main.async {
////                    NewHud.dismiss(from: self.view)
//                    ActivityIndicatorView.shared.stopLoading()
//                    NewSimpleAlert.shared.showAlert(in: self, title: error.localizedDescription, message: "")
//                }
//           }
//        }
//    }
//
//        func SendOtp() {
//            otpViewModel.mobile = TFMobile.textField.text
//
//            otpViewModel.SendOtp{[weak self] state in
//                guard let self = self else{return}
//                guard let state = state else{
//                    return
//                }
//                switch state {
//                case .loading:
//                    Hud.showHud(in: self.view)
//                case .stopLoading:
//                    Hud.dismiss(from: self.view)
//                case .success:
//                    Hud.dismiss(from: self.view)
//                    print(state)
//                    //        guard let seconds = viewModel.responseModel?.secondsCount else {return}
//                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
//                    vc.Phonenumber = TFMobile.textField.text
//                    vc.second =  otpViewModel.responseModel?.secondsCount ?? 60
//                    vc.otp = otpViewModel.responseModel?.otp ?? 00
//                    Shared.shared.remainingSeconds = otpViewModel.responseModel?.secondsCount ?? 60
//                    vc.verivyFor = .forgetPassword
//                    navigationController?.pushViewController(vc, animated: true)
//                case .error(let code,let error):
//                    Hud.dismiss(from: self.view)
//                    SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion:{
//                        if code == 400 {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    })
//                    print(error ?? "")
//                case .none:
//                    print("")
//                }
//            }
//        }
//}





func pushUIKitVC(_ vc: UIViewController) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let root = windowScene.windows.first?.rootViewController else {
        return
    }
    // Determine current language direction
    let isArabic = LocalizationManager.shared.currentLanguage == "ar"
    let direction: UISemanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
    
    // Get the top most navigation controller
    var top = root
    while let presented = top.presentedViewController {
        top = presented
    }
    
    if let nav = top as? UINavigationController {
          nav.view.semanticContentAttribute = direction
          nav.pushViewController(vc, animated: true)
      } else {
          let nav = UINavigationController(rootViewController: vc)
          nav.view.semanticContentAttribute = direction
          top.present(nav, animated: true)
      }
}

struct CustomInputFieldUI: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showToggle: Bool = false
    var isValid: Bool = true
    var isDisabled: Bool? = false
    var isMultilineText:Bool? = false
    var isIconOnTop:Bool? = false

    /// Optional trailing view (e.g. icon, icon+arrow)
    var trailingView: AnyView? = nil
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        let borderColor = isValid ? Color.gray.opacity(0.4) : Color(.wrong)
        let textColor = isValid ? Color(.mainBlue) : Color(.wrong)
        
        VStack(spacing: 2) {
            HStack{
                Text(title.localized)
                    .font(.semiBold(size: 20))
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
             
                if isIconOnTop == true, let view = trailingView {
                    view
                }
            }
            
            HStack(spacing: 8) {
                if isMultilineText == false{
                    TextFieldWrapper
                        .frame(height: 32)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .disabled(isDisabled ?? false)
                }else{
                    MultiLineTextFieldWrapper
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .disabled(isDisabled ?? false)
                        .lineLimit(4)
                }

                if isIconOnTop == false, let view = trailingView {
                    view
                }
                
                if showToggle {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(isValid ? Color(.secondary):textColor)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            Divider()
                .frame(height: 1.5)
                .background(borderColor)
        }
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    private var TextFieldWrapper: some View {
            if isSecure && !isPasswordVisible {
                SecureField(placeholder.localized, text: $text)
                    .padding(.leading, 4)
                    .font(.medium(size: 16))
                    .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
            } else {
                TextField(placeholder.localized, text: $text)
                    .padding(.leading, 4)
                    .font(.medium(size: 16))
                    .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
            }


    }
    @ViewBuilder
    private var MultiLineTextFieldWrapper: some View {
            if #available(iOS 16.0, *) {
                TextField(placeholder.localized, text: $text, axis: .vertical)
                    .font(.regular(size: 16))
                    .multilineTextAlignment(.leading)
//                    .foregroundColor(Color(.main))
                    .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
                    .tint(.mainBlue)
                    .frame(minHeight: 60)
            } else {
                MultilineTextField(placeholder.localized, text: $text, onCommit: {})
                    .font(.regular(size: 16))
                    .frame(minHeight: 60)
//                    .background(Color(.messageSenderBg).cornerRadius(7))
                    .foregroundColor(isValid ? Color(.mainBlue) : Color(.wrong))
            }
        

    }
}

struct CustomHeaderUI: View {
    var title: String?
    var subtitle: String?
    var body: some View {
        VStack(spacing: 8){
            Text(title ?? "")
                .font(.bold(size: 36))
                .foregroundColor(Color(.mainBlue))
                .frame(maxWidth: .infinity,alignment: .leading)
            
            Text(subtitle ?? "")
                .font(.medium(size: 18))
                .foregroundColor(Color(.secondary))
                .frame(maxWidth: .infinity,alignment: .leading)
        }
    }
}

struct CustomButtonUI: View {
    var title: String? = ""
    var isValid: Bool? = true
    var action: (() -> Void)?
    var body: some View {
        Button(action: {
            // Validate and login
            action?()
        }) {
            Text(title?.localized ?? "")
                .font(.bold(size: 24))
                .foregroundColor(isValid ?? true ? Color(.white) : Color(.btnDisabledTxt))
                .frame(maxWidth: .infinity)
                .padding()
                .background{
                    if isValid ?? true {
                        Color.clear.horizontalGradientBackground()
                    }else{
                        Color(.btnDisabledBg)
                    }
                }
                .cornerRadius(3)
            
        }
        .disabled(!(isValid ?? true))
    }
}
