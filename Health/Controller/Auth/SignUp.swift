//
//  SignUp.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit

class SignUp: UIViewController  , UITextFieldDelegate{

    @IBOutlet weak var TFName: UITextField!
    @IBOutlet weak var ViewName: UIView!
    @IBOutlet weak var BtnName: UIView!
    
    @IBOutlet weak var TFPhone: UITextField!
    @IBOutlet weak var ViewPhoneNum: UIView!
    @IBOutlet weak var BtnPhone: UIView!
    
    
    @IBOutlet weak var TFDistrict: UITextField!
    @IBOutlet weak var ViewDistrict: UIView!
    @IBOutlet weak var BtnDistrict: UIView!
    
    
    @IBOutlet weak var TFCode: UITextField!
    @IBOutlet weak var ViewCode: UIView!
    @IBOutlet weak var BtnCode: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TFName.delegate = self
        BtnName.isHidden = true
        
        TFPhone.delegate = self
        BtnPhone.isHidden = true
        
        TFCode.delegate = self
        BtnCode.isHidden = true
    }
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BULogin(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
          
          if textField == TFPhone {
              TFPhone.textColor = UIColor(named: "main")
              ViewPhoneNum.borderColor = UIColor(named: "stroke")
          } else if textField == TFName {
              ViewName.borderColor = UIColor(named: "stroke")
              TFName.textColor = UIColor(named: "main")
          } else if textField == TFCode {
              ViewCode.borderColor = UIColor(named: "stroke")
              TFCode.textColor = UIColor(named: "main")
          }  else {
              
          }
      }
    
      func textFieldDidEndEditing(_ textField: UITextField) {
          
          if textField == TFPhone {
              if TFPhone.text?.count == 0 {
                  BtnPhone.isHidden = true
              } else {
                  BtnPhone.isHidden = false
              }
              
          } else  if textField == TFName {
              if TFName.text?.count == 0 {
                  BtnName.isHidden = true
              } else {
                  BtnName.isHidden = false
              }
              
          } else  if textField == TFCode {
              if TFCode.text?.count == 0 {
                  BtnCode.isHidden = true
              } else {
                  BtnCode.isHidden = false
              }
          } else {
          }
          
      }
    
    
  
}
