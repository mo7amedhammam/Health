//
//  ForgetPasswordVC.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit

class ForgetPasswordVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var TFPassword: UITextField!
    
    @IBOutlet weak var ViewRe_Password: UIView!
    @IBOutlet weak var TFRe_Password: UITextField!
    
    @IBOutlet weak var BtnReset: UIButton!
    var Phonenumber : String?
    let ViewModel = ForgetPasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TFPassword.delegate = self
        TFRe_Password.delegate = self
        TFPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFRe_Password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        BtnReset.enable(false)

        hideKeyboardWhenTappedAround()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == TFPassword {
            TFPassword.textColor = UIColor(named: "main")
            ViewPassword.borderColor = UIColor(named: "stroke")
            
        } else if textField == TFRe_Password {
            ViewRe_Password.borderColor = UIColor(named: "stroke")
            TFRe_Password.textColor = UIColor(named: "main")
        } else {
            
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isPasswordValid = TFPassword.text?.count ?? 0 >= 5 // Check if TFPhone has 11 digits
        let isRePasswordValid = TFRe_Password.hasText // Check if TFPassword is not empty
        let isMatched = (TFPassword.text == TFRe_Password.text)
        let isValidForm = isPasswordValid && isRePasswordValid && isMatched
        BtnReset.enable(isValidForm)
    }
    
    //      func textFieldDidEndEditing(_ textField: UITextField) {
    //
    //          if textField == TFPassword {
    //              if TFPassword.text?.count == 0 {
    //              } else {
    //              }
    //
    //          }  else {
    //          }
    //
    //      }
    
    
    
    @IBAction func BURe_Set(_ sender: Any) {
        ResetPassword()
    }
    
    @IBAction func BUBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }    
    
    @IBAction func BUShowPassword(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if sender.isSelected == false {
                sender.isSelected = true
                TFPassword.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                TFPassword.isSecureTextEntry = true
            }
        } else {
            if sender.isSelected == false {
                sender.isSelected = true
                TFRe_Password.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                TFRe_Password.isSecureTextEntry = true
            }
            
        }
        
        
    }
}

extension ForgetPasswordVC {
    func ResetPassword(){
        ViewModel.mobile = Phonenumber
        ViewModel.newPassword = TFRe_Password.text
        
        ViewModel.ResetPassword{[weak self] state in
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
                PassResetDone()
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    func PassResetDone()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم إعادة ضبط كلمة المرور بنجاح"
            viewDone.imgStr = "keyicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
                Helper.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
            }
        }
    }
}
