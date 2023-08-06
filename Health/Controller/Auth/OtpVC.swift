//
//  OtpVC.swift
//  Health
//
//  Created by Hamza on 29/07/2023.
//

import UIKit

class OtpVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var LaToNum: UILabel!
    
    @IBOutlet weak var TFIndex1: UITextField!
    @IBOutlet weak var TFIndex2: UITextField!
    @IBOutlet weak var TFIndex3: UITextField!
    @IBOutlet weak var TFIndex4: UITextField!
    
    @IBOutlet weak var ViewTF1: UIView!
    @IBOutlet weak var ViewTF2: UIView!
    @IBOutlet weak var ViewTF3: UIView!
    @IBOutlet weak var ViewTF4: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.TFIndex1.delegate = self
        self.TFIndex2.delegate = self
        self.TFIndex3.delegate = self
        self.TFIndex4.delegate = self
        
        // Text Field Action
        self.TFIndex1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        TFIndex1.becomeFirstResponder()

        
    }
    
    
    
    @IBAction func BUBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          
          if textField == TFIndex1 {
              TFIndex1.text = ""
          } else if textField == TFIndex2 {
              TFIndex2.text = ""
          } else if textField == TFIndex3 {
              TFIndex3.text = ""
          } else if textField == TFIndex4 {
              TFIndex4.text = ""
          } else {
              
          }
      }
    
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text?.utf16.count == 1 {
            
            switch textField{
            case self.TFIndex1:
                
                if TFIndex2.text == "" {
                    self.TFIndex2.becomeFirstResponder()
                } else {
                    if TFIndex3.text == "" {
                        self.TFIndex3.becomeFirstResponder()
                    } else {
                        if TFIndex4.text == "" {
                            self.TFIndex4.becomeFirstResponder()
                        } else {
                            // excute code
                            SendCode ()
                        }
                    }
                }
            case self.TFIndex2:
                
                if TFIndex1.text == "" {
                    self.TFIndex1.becomeFirstResponder()
                } else {
                    if TFIndex3.text == "" {
                        self.TFIndex3.becomeFirstResponder()
                    } else {
                        if TFIndex4.text == "" {
                            self.TFIndex4.becomeFirstResponder()
                        } else {
                            // excute code
                            SendCode ()
                        }
                    }
                }
            case self.TFIndex3:
                
                if TFIndex1.text == "" {
                    self.TFIndex1.becomeFirstResponder()
                } else {
                    if TFIndex2.text == "" {
                        self.TFIndex2.becomeFirstResponder()
                    } else {
                        if TFIndex4.text == "" {
                            self.TFIndex4.becomeFirstResponder()
                        } else {
                            // excute code
                            SendCode ()
                        }
                    }
                }
            case self.TFIndex4:
                if TFIndex1.text == "" {
                    self.TFIndex1.becomeFirstResponder()
                } else {
                    if TFIndex2.text == "" {
                        self.TFIndex2.becomeFirstResponder()
                    } else {
                        if TFIndex3.text == "" {
                            self.TFIndex3.becomeFirstResponder()
                        } else {
                            // excute code
                            SendCode ()
                        }
                    }
                }
            default:
                break
            }
        } else {
            
//            switch textField{
//            case self.TFIndex1:
//                self.TFIndex2.becomeFirstResponder()
//            case self.TFIndex2:
//                self.TFIndex3.becomeFirstResponder()
//            case self.TFIndex3:
//                self.TFIndex4.becomeFirstResponder()
//            case self.TFIndex4:
//                self.TFIndex4.resignFirstResponder()
//            default:
//                break
//            }
        }
    }
    
    func SendCode () {
        
        
    }
    
    @IBAction func BUDontReceive(_ sender: Any) {
    }
    
    @IBAction func BUResend(_ sender: Any) {
    }
    
    @IBAction func BUConfirm(_ sender: Any) {
    }
    
    
}
