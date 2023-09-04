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
    
    let loginViewModel = LoginVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TFPhone.delegate = self
        TFPassword.delegate = self
        BtnPhone.isHidden = true
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUForgetPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
        
    @IBAction func BULogin(_ sender: Any) {
        Login()
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func BUShowPassword(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            TFPassword.isSecureTextEntry = false
        } else {
            sender.isSelected = false
            TFPassword.isSecureTextEntry = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
          if textField == TFPhone {
              TFPhone.textColor = UIColor(named: "main")
              ViewPhoneNum.borderColor = UIColor(named: "stroke")

          } else if textField == TFPassword {
              ViewPassword.borderColor = UIColor(named: "stroke")
              TFPassword.textColor = UIColor(named: "main")
          } else {
          }
      }
    
      func textFieldDidEndEditing(_ textField: UITextField) {
          
          if textField == TFPhone {
              if TFPhone.text?.count == 0 {
                  BtnPhone.isHidden = true
              } else {
                  BtnPhone.isHidden = false
              }
              
          } else  if textField == TFPassword {
              if TFPassword.text?.count == 0 {
              
              } else {
              }
              
          } else {
          }
      }
    
}


//MARK: ---- functions -----
extension LoginVC{
    func Login() {
        loginViewModel.mobile = TFPhone.text
        loginViewModel.password = TFPassword.text

        loginViewModel.login { [self] success, errorMessage in
            if success {
                // Login was successful, you can navigate to the next screen or perform other actions.
                // For example, show the home screen.
                //                self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
                print("userModel",loginViewModel.usermodel ?? LoginM())
            } else {
                // Handle login failure, show an error message, etc.
                print("Login error: \(errorMessage)")
            }
        }
    }
}
