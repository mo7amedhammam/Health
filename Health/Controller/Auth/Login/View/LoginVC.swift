//
//  CustomTextField.swift
//  Sehaty
//
//  Created by mohamed hammam on 07/04/2025.
//

import UIKit

final class LoginVC: UIViewController {
    
    @IBOutlet weak var TFMobile: CustomInputField!
    @IBOutlet weak var TFPassword: CustomInputField!

    @IBOutlet weak var BtnForgetPassword: UIButton!
    @IBOutlet private weak var BtnLogin: UIButton!

    @IBOutlet weak var STDontHaveAccount: UIStackView!
    @IBOutlet weak var LaDontHaveAccount: UILabel!
   
    @IBOutlet weak var BtnCreateAccount: UIButton!
    private var isMobileValid = false
    private var isPasswordValid = false

    private let validationTooltip = UILabel()

    private var viewModel: LoginViewModelProtocol
    let otpViewModel = OtpVM()

    init(viewModel: LoginViewModelProtocol = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshLocalization()

        setupUI()
//        setupBindings()
        setupValidation()
//        refreshLocalization
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocalization()
    }
    
    private func setupUI() {
        BtnForgetPassword.underlineCurrentTitle()
        BtnLogin.isEnabled(false)
        hideKeyboardWhenTappedAround()
    }
    private func refreshLocalization() {
        let isRTL = Helper.shared.getLanguage() == "ar"
           // Refresh all localizable elements
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[self] in

            BtnLogin.setTitle("login_signin_btn".localized, for: .normal)
            BtnForgetPassword.setTitle("login_forget_Password".localized, for: .normal)
        LaDontHaveAccount.text = "login_not_signin".localized
        BtnCreateAccount.setTitle("login_signup_btn".localized, for: .normal)
        
            BtnForgetPassword.semanticContentAttribute = !isRTL ? .forceRightToLeft : .forceLeftToRight
            STDontHaveAccount.semanticContentAttribute = !isRTL ? .forceRightToLeft : .forceLeftToRight
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
//        })
       }
    
    private func setupValidation() {
         // Mobile Validation
         TFMobile.validationRule = { [weak self] text in
             guard let self = self , let text = text else { return false }
             let isValid = text.count == 11 && text.starts(with: "01")
             return isValid
         }
        TFMobile.onValidationChanged = { [weak self] isValid in
            self?.isMobileValid = isValid
            self?.updateLoginButtonState()
        }
          
        // Example of advanced password validation
        TFPassword.validationRule = {[weak self] text in
            guard let self = self, let text = text else { return false }
            // At least 6 characters, with 1 uppercase, 1 digit
//            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*\\d).{6,}$")
//            return passwordTest.evaluate(with: text)
            
            let isValid = text.count >= 6
            return isValid
        }
          
          TFPassword.onValidationChanged = { [weak self] isValid in
              self?.isPasswordValid = isValid
              self?.updateLoginButtonState()
          }
          
          // Trigger initial validation
//          TFMobile.validateField()
//          TFPassword.validateField()
      }
    @objc private func mobileFieldDidChange() {
         // Enforce 11 character limit
        if let text = TFMobile.textField.text, text.count > 11 {
             TFMobile.textField.text = (String(text.prefix(11)))
         }
//         TFMobile.validateField()
     }
    
    private func updateLoginButtonState() {
            BtnLogin.isEnabled(isMobileValid && isPasswordValid)
            
            // Optional: Change button appearance based on state
//            BtnLogin.alpha = (isMobileValid && isPasswordValid) ? 1.0 : 0.6
        }
    
        @IBAction func BUForgetPassword(_ sender: Any) {
            if TFMobile.textField.text != ""{
                SendOtp()
            } else {
                SimpleAlert.shared.showAlert(title: "اكتب رقم موبايل الأول", message: "", viewController: self)
                return
            }
        }
    @IBAction private func BULogin(_ sender: Any) {
        login()
    }
        @IBAction func BUSignUp(_ sender: Any) {
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else{return}
            navigationController?.pushViewController(vc, animated: true)
        }
    
    private func login() {
        viewModel.mobile = TFMobile.textField.text
        viewModel.password = TFPassword.textField.text
        
        DispatchQueue.main.async {
            ActivityIndicatorView.shared.startLoading(in: self.view)
        }
        viewModel.login { [weak self] result in
            guard let self = self else { return }
   
            switch result {
            case .success:
                DispatchQueue.main.async {
//                    NewHud.dismiss(from: self.view)
                    ActivityIndicatorView.shared.stopLoading()

                    Helper.shared.saveUser(user: self.viewModel.usermodel ?? LoginM())
                    Helper.shared.changeRootVC(newroot: HTBC.self, transitionFrom: .fromLeft)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
//                    NewHud.dismiss(from: self.view)
                    ActivityIndicatorView.shared.stopLoading()
                    NewSimpleAlert.shared.showAlert(in: self, title: error.localizedDescription, message: "")
                }
           }
        }
    }
    
        func SendOtp() {
            otpViewModel.mobile = TFMobile.textField.text
    
            otpViewModel.SendOtp{[weak self] state in
                guard let self = self else{return}
                guard let state = state else{
                    return
                }
                switch state {
                case .loading:
                    Hud.showHud(in: self.view)
                case .stopLoading:
                    Hud.dismiss(from: self.view)
                case .success:
                    Hud.dismiss(from: self.view)
                    print(state)
                    //        guard let seconds = viewModel.responseModel?.secondsCount else {return}
                    guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
                    vc.Phonenumber = TFMobile.textField.text
                    vc.second =  otpViewModel.responseModel?.secondsCount ?? 60
                    Shared.shared.remainingSeconds = otpViewModel.responseModel?.secondsCount ?? 60
                    vc.otp = "استخدم \(otpViewModel.responseModel?.otp ?? 00)"
                    navigationController?.pushViewController(vc, animated: true)
                case .error(let code,let error):
                    Hud.dismiss(from: self.view)
                    SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion:{
                        if code == 400 {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                    print(error ?? "")
                case .none:
                    print("")
                }
            }
        }
}
