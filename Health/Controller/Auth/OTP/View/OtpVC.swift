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
    @IBOutlet weak var TFIndex5: UITextField!
    @IBOutlet weak var TFIndex6: UITextField!

    @IBOutlet weak var ViewTF1: UIView!
    @IBOutlet weak var ViewTF2: UIView!
    @IBOutlet weak var ViewTF3: UIView!
    @IBOutlet weak var ViewTF4: UIView!
    @IBOutlet weak var ViewTF5: UIView!
    @IBOutlet weak var ViewTF6: UIView!
    @IBOutlet weak var BtnResend: UIButton!
    var Phonenumber:String?
    @IBOutlet weak var SecondsCount: UILabel!
    
    var timer: Timer?

    let viewModel = OtpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.TFIndex1.delegate = self
        self.TFIndex2.delegate = self
        self.TFIndex3.delegate = self
        self.TFIndex4.delegate = self
        self.TFIndex5.delegate = self
        self.TFIndex6.delegate = self

        // Text Field Action
        self.TFIndex1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex5.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.TFIndex6.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

        TFIndex1.becomeFirstResponder()
        LaToNum.text = Phonenumber
        
        hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SendOtp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    @IBAction func BUBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          if textField == TFIndex1 {
              TFIndex1.text = ""
              TFIndex1.textColor = UIColor(named: "main")
              ViewTF1.backgroundColor = .white
          } else if textField == TFIndex2 {
              TFIndex2.text = ""
              TFIndex2.textColor = UIColor(named: "main")
              ViewTF2.backgroundColor = .white
          } else if textField == TFIndex3 {
              TFIndex3.text = ""
              TFIndex3.textColor = UIColor(named: "main")
              ViewTF3.backgroundColor = .white
          } else if textField == TFIndex4 {
              TFIndex4.text = ""
              TFIndex4.textColor = UIColor(named: "main")
              ViewTF4.backgroundColor = .white
          } else if textField == TFIndex5 {
              TFIndex5.text = ""
              TFIndex5.textColor = UIColor(named: "main")
              ViewTF5.backgroundColor = .white
          } else if textField == TFIndex6 {
              TFIndex6.text = ""
              TFIndex6.textColor = UIColor(named: "main")
              ViewTF6.backgroundColor = .white
          } else {
          }
      }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField{
            case self.TFIndex1:
                if !TFIndex1.text!.isEmpty {
                    TFIndex1.textColor = .white
                    ViewTF1.backgroundColor = UIColor(named: "main")
                    self.TFIndex2.becomeFirstResponder()
                } else {
                    ViewTF1.backgroundColor = .clear
                }
                
                
            case self.TFIndex2:
                if !TFIndex2.text!.isEmpty {
                    TFIndex2.textColor = .white
                    ViewTF2.backgroundColor = UIColor(named: "main")
                    self.TFIndex3.becomeFirstResponder()
                } else {
                    ViewTF2.backgroundColor = .clear
                }

            case self.TFIndex3:
                if !TFIndex3.text!.isEmpty {
                    TFIndex3.textColor = .white
                    ViewTF3.backgroundColor = UIColor(named: "main")
                    self.TFIndex4.becomeFirstResponder()
                } else {
                    ViewTF3.backgroundColor = .clear
                }
 
            case self.TFIndex4:
                if !TFIndex4.text!.isEmpty {
                    TFIndex4.textColor = .white
                    ViewTF4.backgroundColor = UIColor(named: "main")
                    self.TFIndex5.becomeFirstResponder()
                } else {
                    ViewTF4.backgroundColor = .clear
                }
            case self.TFIndex5:
                if !TFIndex5.text!.isEmpty {
                    TFIndex5.textColor = .white
                    ViewTF5.backgroundColor = UIColor(named: "main")
                    self.TFIndex6.becomeFirstResponder()
                } else {
                    ViewTF5.backgroundColor = .clear
                }

            case self.TFIndex6:
                if !TFIndex6.text!.isEmpty {
                    TFIndex6.textColor = .white
                    ViewTF6.backgroundColor = UIColor(named: "main")
                    
                    //Make verification action when complete 6 digits
                    VerifyOtp()
                } else {
                    ViewTF6.backgroundColor = .clear
                }
        
            default:
                break
            }
        } else {

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if TFIndex1.text == "" {
            ViewTF1.backgroundColor = .clear
        }
        
        if TFIndex2.text == "" {
            ViewTF2.backgroundColor = .clear
        }
        
        if TFIndex3.text == "" {
            ViewTF3.backgroundColor = .clear
        }
        
        if TFIndex4.text == "" {
            ViewTF4.backgroundColor = .clear
        }
        
        if TFIndex5.text == "" {
            ViewTF5.backgroundColor = .clear
        }
        
        if TFIndex6.text == "" {
            ViewTF6.backgroundColor = .clear
        }

    }
    
    @IBAction func BUDontReceive(_ sender: Any) {
    }
    
    @IBAction func BUResend(_ sender: Any) {
        SendOtp()
    }
    
    @IBAction func BUConfirm(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HTBC") as! HTBC
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false, completion: nil)
    }
    
}


//MARK: ---- functions -----
extension OtpVC{
    func SendOtp() {
        viewModel.mobile = Phonenumber
        
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
            clearOtp()
                guard let seconds = viewModel.responseModel?.secondsCount else {return}
                startTimer(remainingSeconds: seconds)
                
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
    
    func VerifyOtp() {
        viewModel.mobile = Phonenumber
        guard let otp1 = TFIndex1.text ,let otp2 = TFIndex2.text,let otp3 = TFIndex3.text,let otp4 = TFIndex4.text,let otp5 = TFIndex5.text,let otp6 = TFIndex6.text else {return}
        let fullotp = otp1+otp2+otp3+otp4+otp5+otp6
        viewModel.EnteredOtp = fullotp
        viewModel.VerifyOtp{[weak self] state in
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
                gotoResetPassword()
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion: {
                    self.clearOtp()
                })
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
    private func gotoResetPassword(){
        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: ForgetPasswordVC.self) else{return}
        vc.Phonenumber = Phonenumber
         navigationController?.pushViewController(vc, animated: true)
    }
    
    private func clearOtp(){
        TFIndex1.text = ""
        ViewTF1.backgroundColor = .clear
        TFIndex1.becomeFirstResponder()
        
        TFIndex2.text = ""
        ViewTF2.backgroundColor = .clear

        TFIndex3.text = ""
        ViewTF3.backgroundColor = .clear

        TFIndex4.text = ""
        ViewTF4.backgroundColor = .clear

        TFIndex5.text = ""
        ViewTF5.backgroundColor = .clear

        TFIndex6.text = ""
        ViewTF6.backgroundColor = .clear
        
    }
    
    func startTimer(remainingSeconds:Int) {
        timer?.invalidate()
        var remainingSeconds = remainingSeconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if remainingSeconds > 0 {
                remainingSeconds -= 1
                self.SecondsCount.text = "\(timeString(time: TimeInterval(remainingSeconds))) "
                // Still have time, enable the button and invalidate the timer
                self.BtnResend.isEnabled = false
                self.BtnResend.alpha = 0.5
            } else {
                // Time's up, enable the button and invalidate the timer
                self.BtnResend.isEnabled = true
                self.BtnResend.alpha = 1

                timer.invalidate()
            }
        }
    }
    func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)
    }
}
