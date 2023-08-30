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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TFPassword.delegate = self
        TFRe_Password.delegate = self
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
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
