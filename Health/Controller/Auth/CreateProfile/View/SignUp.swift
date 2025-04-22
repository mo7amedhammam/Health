//
//  SignUp.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import DropDown

//enum DrobListSource{
//case Gender,District
//}
class SignUp: UIViewController {
    
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var TFName: CustomInputField!
    @IBOutlet weak var TFPhone: CustomInputField!
    @IBOutlet weak var TFPassword: CustomInputField!
    @IBOutlet weak var TFPasswordConfirm: CustomInputField!
    @IBOutlet weak var BtnRegister: UIButton!
    @IBOutlet weak var STHaveAccount: UIStackView!
    @IBOutlet weak var LaHaveAccount: UILabel!
    @IBOutlet weak var BtnLogin: UIButton!
    
    @IBOutlet weak var BtnBack: UIButton!
    //    @IBOutlet weak var termsCheckboxButton: UIButton!
//    @IBOutlet weak var termsLabel: UILabel!
    
    let ViewModel = SignUpVM()
//    private var isTermsAccepted = false {
//        didSet {
//            let imageName = isTermsAccepted ? "checkbox_checked" : "checkbox_unchecked"
//            termsCheckboxButton.setImage(UIImage(named: imageName), for: .normal)
//            validateForm()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshLocalization()
        setupUI()
//        setupTerms()
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           setupTextFieldsValidation() // Moved to viewDidAppear to ensure views are loaded
       }
    private func setupUI() {
        BtnRegister.isEnabled(false)
        BtnBack.setImage(UIImage(resource:  .backRight).flippedIfRTL, for: .normal)
        hideKeyboardWhenTappedAround()
    }
    
    private func setupTextFieldsValidation() {
        // Name validation - just required
        TFName.validationRule = { text in
            guard let text = text else { return false }
            return !text.isEmpty
        }
        
        // Phone validation - starts with 01, 6-11 digits
        TFPhone.textField.keyboardType = .phonePad
        TFPhone.validationRule = { text in
            guard let text = text else { return false }
            return !text.isEmpty && text.count == 11 && text.starts(with: "01")
        }
        
        // Password validation - at least 6 characters
        TFPassword.validationRule = { text in
            guard let text = text else { return false }
            return !text.isEmpty && text.count >= 6
        }
        
        // Password confirmation - must match password
        TFPasswordConfirm.validationRule = { [weak self] text in
            guard let self = self, let text = text else { return false }
            return !text.isEmpty && text == self.TFPassword.textField.text
        }
        
        // Set up validation change handlers
        [TFName, TFPhone, TFPassword, TFPasswordConfirm].forEach { field in
            field?.onValidationChanged = { [weak self] isValid in
                self?.validateForm()
            }
        }
    }
    
//    private func setupTerms() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
//        termsLabel.isUserInteractionEnabled = true
//        termsLabel.addGestureRecognizer(tapGesture)
//        termsCheckboxButton.addTarget(self, action: #selector(termsCheckboxTapped), for: .touchUpInside)
//    }
    
    @objc private func termsCheckboxTapped() {
//        isTermsAccepted.toggle()
    }
    
    @objc private func termsLabelTapped() {
//        let vc = TermsAndConditionsVC()
//        present(vc, animated: true)
    }
    
    private func validateForm() {
        let isNameValid = TFName.textField.hasText && TFName.isValid
        let isPhoneValid = TFPhone.textField.hasText && TFPhone.isValid
        let isPasswordValid = TFPassword.textField.hasText && TFPassword.isValid
        let isPasswordMatch = TFPasswordConfirm.textField.hasText && TFPasswordConfirm.isValid
        
        BtnRegister.isEnabled(isNameValid && isPhoneValid && isPasswordValid && isPasswordMatch  )
    }
    
    private func refreshLocalization() {
//        let isRTL = Helper.shared.getLanguage() == "ar"
//        ContainerView.semanticContentAttribute = isRTL ? .forceLeftToRight : .forceRightToLeft
        BtnRegister.setTitle("signup_signup_btn".localized, for: .normal)
        LaHaveAccount.text = "signup_have_account".localized()
        BtnLogin.setTitle("signup_signin_btn".localized, for: .normal)
//        termsLabel.text = "signup_accept_terms".localized()
        
//        STHaveAccount.semanticContentAttribute = isRTL ? .forceLeftToRight : .forceRightToLeft
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BULogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
        CreateAccount()
    }
    
//    private func CreateAccount() {
//        ViewModel.name = TFName.textField.text
//        ViewModel.mobile = TFPhone.textField.text
//        ViewModel.password = TFPassword.textField.text
//        
//        ViewModel.SignUp { [weak self] state in
//            guard let self = self, let state = state else { return }
//            
//            switch state {
//            case .loading:
//                Hud.showHud(in: self.view)
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
//                Hud.dismiss(from: self.view)
//                self.GoToOTPVerification()
//            case .error(_, let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title: error ?? "", message: "", viewController: self)
//            case .none:
//                break
//            }
//        }
//    }

    
    func CreateAccount(){
                ViewModel.name = TFName.textField.text
                ViewModel.mobile = TFPhone.textField.text
                ViewModel.password = TFPassword.textField.text
        Task {
            do{
                Hud.showHud(in: self.view)
                try await ViewModel.CreateAccount()
                // Handle success async operations
                Hud.dismiss(from: self.view)
//                TVScreen.reloadData()
                self.GoToOTPVerification()
                
            }catch {
                // Handle any errors that occur during the async operations
                print("Error: \(error)")
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error.localizedDescription,message:"", viewController: self)
            }
        }
    }
    
    private func GoToOTPVerification() {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
        vc.Phonenumber = TFPhone.textField.text
        vc.otp = ViewModel.responseModel?.otp ?? 0
        vc.second =  ViewModel.responseModel?.secondsCount ?? 60
        Shared.shared.remainingSeconds = ViewModel.responseModel?.secondsCount ?? 60
        vc.verivyFor = .CreateAccount
        navigationController?.pushViewController(vc, animated: true)
        
//        if let viewDone: ViewDone = showView(fromNib: ViewDone.self, in: self) {
//            viewDone.title = "تم إرسال طلب انضمامك بنجاح"
//            viewDone.imgStr = "keyicon"
//            viewDone.action = {
//                viewDone.removeFromSuperview()
//                Helper.shared.changeRootVC(newroot: LoginVC.self, transitionFrom: .fromLeft)
//            }
//        }
    }
}

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
