//
//  LoginVC.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

//Key ID:44DR8QTFF9
//Apple ID 6468809984
//23H4SBD5QL (Team ID)
//com.wecancity.Health
//369783459579-gfh6o502h75lkvkddsu4i9kdce17mlfe.apps.googleusercontent.com

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var TFPhone: UITextField!
    @IBOutlet weak var ViewPhoneNum: UIView!
    @IBOutlet weak var BtnPhone: UIView!
    
    @IBOutlet weak var TFPassword: UITextField!
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var BtnSecurePassword: UIButton!
    
    @IBOutlet weak var BtnLogin: UIButton!
    
    let loginViewModel = LoginVM()
    let viewModel = OtpVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TFPhone.delegate = self
        TFPassword.delegate = self
        TFPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        TFPassword.addTarget(self, action: #selector(didTapTFPassword), for: .editingDidEndOnExit)
        
        BtnPhone.isHidden = true
        BtnLogin.enable(false)
        hideKeyboardWhenTappedAround()
    }
    
    
    
    @objc func didTapTFPassword() {
        // Resign the first responder from the UITextField.
//        Login()
        self.view.endEditing(true)
    }
    
    @IBAction func BUBack(_ sender: Any) {
        //        self.dismiss(animated: true)
    }
    
    @IBAction func BUForgetPassword(_ sender: Any) {
        if TFPhone.text != ""{
            SendOtp()
        } else {
            SimpleAlert.shared.showAlert(title: "اكتب رقم موبايل الأول", message: "", viewController: self)
            return
        }
    }
    
    
    func SendOtp() {
        viewModel.mobile = TFPhone.text!
        
        viewModel.SendOtp{[weak self] state in
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
                vc.Phonenumber = TFPhone.text
                vc.second =  viewModel.responseModel?.secondsCount ?? 60
                Shared.shared.remainingSeconds = viewModel.responseModel?.secondsCount ?? 60
                vc.otp = "استخدم \(viewModel.responseModel?.otp ?? 00)"
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
    
    
    
    @IBAction func BULogin(_ sender: Any) {
        Login()
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: SignUp.self) else{return}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BUShowPassword(_ sender: UIButton) {
            sender.isSelected.toggle()
            TFPassword.isSecureTextEntry.toggle()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == TFPhone {
            TFPhone.textColor = UIColor(named: "main")
            ViewPhoneNum.borderColor = UIColor(named: "stroke")
            ViewPhoneNum.backgroundColor = .clear

        } else if textField == TFPassword {
            ViewPassword.borderColor = UIColor(named: "stroke")
            TFPassword.textColor = UIColor(named: "main")
            ViewPassword.backgroundColor = .clear
            BtnSecurePassword.tintColor = UIColor(named: "stroke")
        } else {
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == TFPhone {
            if TFPhone.text?.count ?? 0 < 11  {
                BtnPhone.isHidden = true
                TFPhone.textColor = UIColor(named: "wrong")
                ViewPhoneNum.borderColor = UIColor(named: "wrong")
                ViewPhoneNum.backgroundColor = UIColor(named: "halfwrong")

            } else {
                BtnPhone.isHidden = false
            }
            
        } else  if textField == TFPassword {
            if TFPassword.text?.count ?? 0 < 5 {
                TFPassword.textColor = UIColor(named: "wrong")
                ViewPassword.borderColor = UIColor(named: "wrong")
                ViewPassword.backgroundColor = UIColor(named: "halfwrong")
                BtnSecurePassword.tintColor = UIColor(named: "wrong")
            } else {
            }
            
        } else {
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
        let isPasswordValid = TFPassword.hasText // Check if TFPassword is not empty
        
        let isValidForm = isPhoneValid && isPasswordValid
        BtnLogin.enable(isValidForm)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == TFPhone {
            // Calculate the new length of the text after applying the replacement string
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Check if the new length exceeds the allowed limit (11 digits)
            if newText.count > 11 {
                return false
            }
        }
        return true
    }
    
    
}


//MARK: ---- functions -----
extension LoginVC{
    func Login() {
        loginViewModel.mobile = TFPhone.text
        loginViewModel.password = TFPassword.text
        
        loginViewModel.login {[weak self] state in
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
                // -- go to home
                Helper.saveUser(user: loginViewModel.usermodel ?? LoginM())
                Helper.changeRootVC(newroot: HTBC.self,transitionFrom: .fromLeft)
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
   
    
}
