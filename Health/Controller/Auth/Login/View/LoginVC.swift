//
//  LoginVC.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TFPhone.delegate = self
        TFPassword.delegate = self
        TFPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        BtnPhone.isHidden = true
        BtnLogin.isEnabled = false
        BtnLogin.alpha = BtnLogin.isEnabled ? 1.0 : 0.5
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func BUBack(_ sender: Any) {
        //        self.dismiss(animated: true)
    }
    
    @IBAction func BUForgetPassword(_ sender: Any) {
        if TFPhone.text != ""{
            guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: OtpVC.self) else{return}
            vc.Phonenumber = TFPhone.text
            navigationController?.pushViewController(vc, animated: true)
        } else {
            SimpleAlert.shared.showAlert(title: "اكتب رقم موبايل الأول", message: "", viewController: self)
            return
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
    
    fileprivate func enableBtnLogin(isactive:Bool) {
        // Enable or disable BtnLogin based on conditions
        BtnLogin.isEnabled = isactive
        BtnLogin.alpha = BtnLogin.isEnabled ? 1.0 : 0.5
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
        let isPasswordValid = TFPassword.hasText // Check if TFPassword is not empty
        
        enableBtnLogin(isactive: isPhoneValid && isPasswordValid)
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
                GoHome()
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    func GoHome(){
        Helper.saveUser(user: loginViewModel.usermodel ?? LoginM())
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: HTBC.self)else{return}
        vc.navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
