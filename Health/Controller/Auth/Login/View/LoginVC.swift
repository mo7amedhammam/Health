////
////  LoginVC.swift
////  Health
////
////  Created by Hamza on 27/07/2023.
////
//
////Key ID:44DR8QTFF9
////Apple ID 6468809984
////23H4SBD5QL (Team ID)
////com.wecancity.Health
////369783459579-gfh6o502h75lkvkddsu4i9kdce17mlfe.apps.googleusercontent.com
//
//import UIKit
//
//class LoginVC: UIViewController , UITextFieldDelegate {
//
//    @IBOutlet weak var TFPhone: UITextField!
//    @IBOutlet weak var ViewPhoneNum: UIView!
//    @IBOutlet weak var BtnPhone: UIView!
//
//    @IBOutlet weak var TFPassword: UITextField!
//    @IBOutlet weak var ViewPassword: UIView!
//    @IBOutlet weak var BtnSecurePassword: UIButton!
//
//    @IBOutlet weak var BtnLogin: UIButton!
//
//    let loginViewModel = LoginVM()
//    let viewModel = OtpVM()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        TFPhone.delegate = self
//        TFPassword.delegate = self
//        TFPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        TFPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//
//        TFPassword.addTarget(self, action: #selector(didTapTFPassword), for: .editingDidEndOnExit)
//
//        BtnPhone.isHidden = true
//        BtnLogin.enable(false)
//        BtnLogin.setTitle(AppKeys.BtnLoginTitle.localized, for: .normal)
//        hideKeyboardWhenTappedAround()
//    }
//
//
//
//    @objc func didTapTFPassword() {
//        // Resign the first responder from the UITextField.
////        Login()
//        self.view.endEditing(true)
//    }
//
//    @IBAction func BUBack(_ sender: Any) {
//        //        self.dismiss(animated: true)
//    }
//
//    @IBAction func BUForgetPassword(_ sender: Any) {
//        if TFPhone.text != ""{
//            SendOtp()
//        } else {
//            SimpleAlert.shared.showAlert(title: "اكتب رقم موبايل الأول", message: "", viewController: self)
//            return
//        }
//    }
//
//
//    func SendOtp() {
//        viewModel.mobile = TFPhone.text!
//
//        viewModel.SendOtp{[weak self] state in
//            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            switch state {
//            case .loading:
//                Hud.showHud(in: self.view)
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
//                Hud.dismiss(from: self.view)
//                print(state)
//                //        guard let seconds = viewModel.responseModel?.secondsCount else {return}
//                guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
//                vc.Phonenumber = TFPhone.text
//                vc.second =  viewModel.responseModel?.secondsCount ?? 60
//                Shared.shared.remainingSeconds = viewModel.responseModel?.secondsCount ?? 60
//                vc.otp = "استخدم \(viewModel.responseModel?.otp ?? 00)"
//                navigationController?.pushViewController(vc, animated: true)
//            case .error(let code,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion:{
//                    if code == 400 {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                })
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//
//
//
//    @IBAction func BULogin(_ sender: Any) {
//        Login()
//    }
//
//    @IBAction func BUSignUp(_ sender: Any) {
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else{return}
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func BUShowPassword(_ sender: UIButton) {
//            sender.isSelected.toggle()
//            TFPassword.isSecureTextEntry.toggle()
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField == TFPhone {
//            TFPhone.textColor = UIColor(named: "main")
//            ViewPhoneNum.borderColor = UIColor(named: "stroke")
//            ViewPhoneNum.backgroundColor = .clear
//
//        } else if textField == TFPassword {
//            ViewPassword.borderColor = UIColor(named: "stroke")
//            TFPassword.textColor = UIColor(named: "main")
//            ViewPassword.backgroundColor = .clear
//            BtnSecurePassword.tintColor = UIColor(named: "stroke")
//        } else {
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if textField == TFPhone {
//            if TFPhone.text?.count ?? 0 < 11  {
//                BtnPhone.isHidden = true
//                TFPhone.textColor = UIColor(named: "wrong")
//                ViewPhoneNum.borderColor = UIColor(named: "wrong")
//                ViewPhoneNum.backgroundColor = UIColor(named: "halfwrong")
//
//            } else {
//                BtnPhone.isHidden = false
//            }
//
//        } else  if textField == TFPassword {
//            if TFPassword.text?.count ?? 0 < 5 {
//                TFPassword.textColor = UIColor(named: "wrong")
//                ViewPassword.borderColor = UIColor(named: "wrong")
//                ViewPassword.backgroundColor = UIColor(named: "halfwrong")
//                BtnSecurePassword.tintColor = UIColor(named: "wrong")
//            } else {
//            }
//
//        } else {
//        }
//    }
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
//        let isPasswordValid = TFPassword.hasText // Check if TFPassword is not empty
//
//        let isValidForm = isPhoneValid && isPasswordValid
//        BtnLogin.enable(isValidForm)
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == TFPhone {
//            // Calculate the new length of the text after applying the replacement string
//            let currentText = textField.text ?? ""
//            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//
//            // Check if the new length exceeds the allowed limit (11 digits)
//            if newText.count > 11 {
//                return false
//            }
//        }
//        return true
//    }
//
//
//}
//
//
////MARK: ---- functions -----
//extension LoginVC{
//    func Login() {
//        loginViewModel.mobile = TFPhone.text
//        loginViewModel.password = TFPassword.text
//
//        loginViewModel.login {[weak self] state in
//            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            switch state {
//            case .loading:
//                Hud.showHud(in: self.view)
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
////                DispatchQueue.main.async{ [weak self] in
////                    guard let self = self else{return}
//                    Hud.dismiss(from: self.view)
//                    print(state)
//                // -- go to home
//                    Helper.shared.saveUser(user: loginViewModel.usermodel ?? LoginM())
//                    Helper.shared.changeRootVC(newroot: HTBC.self,transitionFrom: .fromLeft)
////                }
//                case .error(_,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//
//
//
//}



import UIKit

final class LoginVC: UIViewController {
    
    @IBOutlet weak var TFMobile: CustomTextField!
    @IBOutlet weak var TFPassword: CustomTextField!

    @IBOutlet weak var BtnForgetPassword: UIButton!
    @IBOutlet private weak var BtnLogin: UIButton!

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
        setupUI()
//        setupBindings()
        setupValidation()
    }
    
    private func setupUI() {
        BtnForgetPassword.underlineCurrentTitle()
        BtnLogin.isEnabled(false)
        hideKeyboardWhenTappedAround()
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
         if let text = TFMobile.text(), text.count > 11 {
             TFMobile.textField.text = (String(text.prefix(11)))
         }
//         TFMobile.validateField()
     }
    
    private func updateLoginButtonState() {
            BtnLogin.isEnabled(isMobileValid && isPasswordValid)
            
            // Optional: Change button appearance based on state
//            BtnLogin.alpha = (isMobileValid && isPasswordValid) ? 1.0 : 0.6
        }

    
//    private func setupBindings() {
//        // Example: Update UI based on ViewModel state
//    }
//       @IBAction func BUBack(_ sender: Any) {
//            //        self.dismiss(animated: true)
//        }
    
        @IBAction func BUForgetPassword(_ sender: Any) {
            if TFMobile.text() != ""{
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
//    @IBAction private func BUShowPassword(_ sender: UIButton) {
//        sender.isSelected.toggle()
//        TFPasswordold.isSecureTextEntry.toggle()
//    }
    
    private func login() {
        viewModel.mobile = TFMobile.text()
        viewModel.password = TFPassword.text()
        
        DispatchQueue.main.async {
//            NewHud.show(in: self.view)
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
            otpViewModel.mobile = TFMobile.text()
    
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
                    vc.Phonenumber = TFMobile.text()
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
// MARK: - UITextFieldDelegate
//extension LoginVC: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == TFMobile.textField {
//            let currentText = textField.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            
//            // Only allow numbers and limit to 11 characters
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet) && updatedText.count <= 11
//        }
//        return true
//    }
//}

@IBDesignable
class CustomTextField: UIView {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
     let textField = UITextField()
    private let separatorView = UIView()
    private let iconImageView = UIImageView()
    private let passwordToggleButton = UIButton(type: .custom)
    
    // MARK: - Localizable Properties
    @IBInspectable var titleKey: String = "" {
        didSet { titleLabel.text = NSLocalizedString(titleKey, comment: "") }
    }
    
    @IBInspectable var placeholderKey: String = "" {
        didSet { textField.placeholder = NSLocalizedString(placeholderKey, comment: "") }
    }
    
    // MARK: - Font Properties
    @IBInspectable var titleFontName: String = "" {
        didSet { updateTitleFont() }
    }
    
    @IBInspectable var titleFontSize: CGFloat = 16 {
        didSet { updateTitleFont() }
    }
    
    @IBInspectable var textFontName: String = "" {
        didSet { updateTextFont() }
    }
    
    @IBInspectable var textFontSize: CGFloat = 12 {
        didSet { updateTextFont() }
    }
    
    // MARK: - New Properties for Character Limiting
      @IBInspectable var maxCharacterCount: Int = 0 {
          didSet {
              if maxCharacterCount > 0 {
                  textField.delegate = self
              }
          }
      }
    
    // MARK: - Validation Properties
    @IBInspectable var errorColor: UIColor = .red {
        didSet { updateErrorState() }
    }
    
    private var isValid: Bool = true {
        didSet { updateErrorState() }
    }
    
    var validationRule: ((String?) -> Bool)? {
        didSet { validate() }
    }
    
    var onValidationChanged: ((Bool) -> Void)?
    
    // MARK: - Other Properties
    @IBInspectable var icon: UIImage? {
        didSet { iconImageView.image = icon?.withRenderingMode(.alwaysTemplate) }
    }
    
    @IBInspectable var isPasswordField: Bool = false {
        didSet { setupPasswordToggle() }
    }
    
    @IBInspectable var separatorColor: UIColor = UIColor.lightGray {
        didSet { separatorView.backgroundColor = separatorColor }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet { textField.textColor = textColor }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.darkGray {
        didSet { titleLabel.textColor = titleColor }
    }
    
    @IBInspectable var iconColor: UIColor = UIColor.gray {
        didSet { iconImageView.tintColor = iconColor }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Title Label
        titleLabel.textAlignment = .right
        titleLabel.textColor = titleColor
        updateTitleFont()
        
        // Text Field
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.textColor = textColor
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateTextFont()
        
        // Icon ImageView
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = iconColor
        
        // Separator
        separatorView.backgroundColor = separatorColor
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(separatorView)
        addSubview(iconImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Text Field
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon
            iconImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Separator
            separatorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 2),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2)
        ])
    }
    
    // MARK: - Font Methods
    private func updateTitleFont() {
        if !titleFontName.isEmpty, let font = UIFont(name: titleFontName, size: titleFontSize) {
            titleLabel.font = font
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    private func updateTextFont() {
        if !textFontName.isEmpty, let font = UIFont(name: textFontName, size: textFontSize) {
            textField.font = font
        } else {
            textField.font = UIFont.systemFont(ofSize: textFontSize)
        }
    }
    
    // MARK: - Modified Validation Methods
      private func validate() {
          guard let rule = validationRule else { return }
          
          let isEmpty = textField.text?.isEmpty ?? true
          let newIsValid = isEmpty ? true : rule(textField.text)
          
          if newIsValid != isValid {
              isValid = newIsValid
              onValidationChanged?(isValid && !isEmpty)
          }
      }
    
    private func updateErrorState() {
         let isEmpty = textField.text?.isEmpty ?? true
         
         if isEmpty {
             // Reset to default colors when empty
             titleLabel.textColor = titleColor
             textField.textColor = textColor
             separatorView.backgroundColor = separatorColor
         } else {
             // Apply validation colors only when not empty
             let color = isValid || isEmpty ? titleColor : errorColor
             titleLabel.textColor = color
             textField.textColor = isValid || isEmpty ? textColor : errorColor
             separatorView.backgroundColor = isValid || isEmpty ? separatorColor : errorColor
         }
     }
    
    @objc private func textFieldDidChange() {
        validate()
    }
    
    // MARK: - Password Toggle
    private func setupPasswordToggle() {
        guard isPasswordField else {
            passwordToggleButton.removeFromSuperview()
            textField.isSecureTextEntry = false
            return
        }
        
        passwordToggleButton.setImage(UIImage(resource: .eyeIcon), for: .normal)
        passwordToggleButton.tintColor = iconColor
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        addSubview(passwordToggleButton)
        
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordToggleButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 0),
            passwordToggleButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            passwordToggleButton.widthAnchor.constraint(equalToConstant: 24),
            passwordToggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        textField.isSecureTextEntry = true
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        passwordToggleButton.setImage(UIImage(resource: .eyeIcon), for: .normal)
    }
    
    // MARK: - Public Methods
    func text() -> String? {
        return textField.text
    }
    
    func showError() {
        isValid = false
    }
    
    func hideError() {
        isValid = true
    }
    
    func validateField() -> Bool {
        validate()
        return isValid
    }
    
    // MARK: - RTL Support
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            // Adjust for RTL
            titleLabel.textAlignment = .right
            textField.textAlignment = .right
            textField.semanticContentAttribute = .forceRightToLeft
            
            // Move icon to the right side
            NSLayoutConstraint.deactivate(iconImageView.constraints)
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
            
            // Move password toggle to the left side
            if isPasswordField {
                NSLayoutConstraint.deactivate(passwordToggleButton.constraints)
                passwordToggleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            }
        }
    }
}

// MARK: - Text Field Delegate
   extension CustomTextField: UITextFieldDelegate {
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard maxCharacterCount > 0 else { return true }
           
           let currentText = textField.text ?? ""
           guard let stringRange = Range(range, in: currentText) else { return false }
           let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
           
           return updatedText.count <= maxCharacterCount
       }
   }


