//
//  ChangePasswordVC.swift
//  Health
//
//  Created by Hamza on 29/07/2023.
//

import UIKit

class ChangePasswordVC: UIViewController  , UITextFieldDelegate {
    
    
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var TFPassword: UITextField!
    
    @IBOutlet weak var ViewNewPassword: UIView!
    @IBOutlet weak var TFNewPassword: UITextField!
    
    @IBOutlet weak var ViewRe_Password: UIView!
    @IBOutlet weak var TFRe_Password: UITextField!
    
    let ViewModel = ChangePasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TFPassword.delegate = self
        TFNewPassword.delegate = self
        TFRe_Password.delegate = self
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == TFPassword {
            TFPassword.textColor = UIColor(named: "main")
            ViewPassword.borderColor = UIColor(named: "stroke")
        } else if textField == TFNewPassword {
            TFNewPassword.borderColor = UIColor(named: "stroke")
            TFNewPassword.textColor = UIColor(named: "main")
        } else if textField == TFRe_Password {
            ViewRe_Password.borderColor = UIColor(named: "stroke")
            TFRe_Password.textColor = UIColor(named: "main")
        } else {
            
        }
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        } else if sender.tag == 1 {
            if sender.isSelected == false {
                sender.isSelected = true
                TFNewPassword.isSecureTextEntry = false
            } else {
                sender.isSelected = false
                TFNewPassword.isSecureTextEntry = true
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
    
    @IBAction func BUChange(_ sender: Any) {
        ChangePassword()
    }
    
}

extension ChangePasswordVC {
    func ChangePassword(){
        ViewModel.oldPassword = TFPassword.text
        ViewModel.newPassword = TFRe_Password.text
        
        ViewModel.ChangePassword{[self] state in
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
                PassChangedDone()
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    func PassChangedDone()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم تغيير ضبط كلمة المرور بنجاح"
            viewDone.imgStr = "keyicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
                Helper.changeRootVC(newroot: LoginVC.self)
            }
        }
    }
}
