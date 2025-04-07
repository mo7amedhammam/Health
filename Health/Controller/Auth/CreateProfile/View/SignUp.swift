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
class SignUp: UIViewController  , UITextFieldDelegate{
    
    @IBOutlet weak var TFName: UITextField!
    @IBOutlet weak var ViewName: UIView!
    @IBOutlet weak var BtnName: UIView!
    
    @IBOutlet weak var TFPhone: UITextField!
    @IBOutlet weak var ViewPhoneNum: UIView!
    @IBOutlet weak var BtnPhone: UIView!
    
    @IBOutlet weak var TFPassword: UITextField!
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var BtnPassword: UIButton!
    var DistrictId: Int?
    
    @IBOutlet weak var TFPasswordConfirm: UITextField!
    @IBOutlet weak var ViewPasswordConfirm: UIView!
    @IBOutlet weak var BtnPasswordConfirm: UIButton!
    var GenderId: Int?
    
//    @IBOutlet weak var TFCode: UITextField!
//    @IBOutlet weak var ViewCode: UIView!
//    @IBOutlet weak var BtnCode: UIView!
    
    @IBOutlet weak var BtnRegister: UIButton!
    //    let dataArray = ["الدمام", "مكة", "الرياض", "بريدة", "القصيم"]
    let rightBarDropDown = DropDown()
    
    let ViewModel = SignUpVM()
    var select = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TFName.delegate = self
//        BtnName.isHidden = true
        
        TFPhone.delegate = self
//        BtnPhone.isHidden = true

        TFPassword.delegate = self
//        BtnPassword.isHidden = true

        TFPasswordConfirm.delegate = self
//        BtnPasswordConfirm.isHidden = true

//        TFCode.delegate = self
//        BtnCode.isHidden = true
        
        TFName.addTarget(self, action: #selector(didTapSearchButton), for: .editingDidEndOnExit)
//        TFCode.addTarget(self, action: #selector(didTapSearchButtonCode), for: .editingDidEndOnExit)
        
        TFName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        TFPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFPasswordConfirm.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        BtnRegister.isEnabled(false)
        hideKeyboardWhenTappedAround()
        
        //        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
//        rightBarDropDown.cancelAction = { [self] in
//            switch select {
//            case "Gender" :
//                BtnPasswordConfirm.isSelected = false
//                if TFPasswordConfirm.text == "" {
//                    ViewPassword.borderColor = UIColor(named: "stroke")
//                    
//                    //                            ViewGender.backgroundColor = UIColor(named: "F5F5F5")
//                }
//            case "District":
//                BtnPassword.isSelected = false
//                if TFPassword.text == "" {
//                    ViewPassword.borderColor     = UIColor(named: "stroke")
//                    //                            ViewDistrict.backgroundColor = UIColor(named: "F5F5F5")
//                }
//            default:
//                print("")
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Task {
//            self.getDistricts()
////            self.getGenders()
//        }
    }
    
    @objc func didTapSearchButton() {
        // Resign the first responder from the UITextField.
        TFPhone.becomeFirstResponder()
    }
    
//    @objc func didTapSearchButtonCode() {
//        // Resign the first responder from the UITextField.
//        TFCode.resignFirstResponder()
//    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BULogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
        SendJoinRequest()
    }
    
//    @IBAction func BUSelectDistrict(_ sender: Any) {
//        ViewPassword.borderColor = UIColor(named: "stroke")
//        SetDropDown(DropListSource: "District")
//    }
    //    @IBAction func showDestrict(_ sender: Any) {
    //        SetDropDown(DropListSource: .District)
    //    }
    
//    @IBAction func BUSelectGender(_ sender: Any) {
//        ViewPasswordConfirm.borderColor = UIColor(named: "stroke")
//        SetDropDown(DropListSource: "Gender")
//    }
    //    @IBAction func showGender(_ sender: Any) {
    //        SetDropDown(DropListSource: .Gender)
    //    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == TFPhone {
            TFPhone.textColor = UIColor(named: "main")
            ViewPhoneNum.borderColor = UIColor(named: "stroke")
        } else if textField == TFName {
            ViewName.borderColor = UIColor(named: "stroke")
            TFName.textColor = UIColor(named: "main")
//        } else if textField == TFCode {
//            ViewCode.borderColor = UIColor(named: "stroke")
//            TFCode.textColor = UIColor(named: "main")
        }else if textField == TFPassword{
            ViewPassword.borderColor = UIColor(named: "stroke")
        }else if textField == TFPasswordConfirm{
            ViewPasswordConfirm.borderColor = UIColor(named: "stroke")
        }else{
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
            
        } else  if textField == TFPassword {
            if TFPassword.text?.count == 0 {
                BtnPassword.isHidden = true
            } else {
                BtnPassword.isHidden = false
            }
        } else if textField == TFPasswordConfirm{
            if TFPasswordConfirm.text?.count == 0 {
                BtnPasswordConfirm.isHidden = true
            } else {
                BtnPasswordConfirm.isHidden = false
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
        let isNameValid = TFName.hasText // Check if TFPassword is not empty
        let isPasswordValid = DistrictId != nil
        let isPasswordConfirmValid = GenderId != nil
        
        let isValidForm = isPhoneValid && isNameValid && isPasswordValid && isPasswordConfirmValid
        BtnRegister.isEnabled(isValidForm)
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
extension SignUp{
//    func getDistricts(){
//        ViewModel.GetDistricts{ [weak self] state in
//            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            self.getGenders()
//
//            switch state {
//            case .loading:
//                Hud.showHud(in: self.view)
//            case .stopLoading:
////                Hud.dismiss(from: self.view)
//                print("")
//            case .success:
////                Hud.dismiss(from: self.view)
//                print(state)
//            case .error(_,let error):
////                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    func getGenders(){
//        ViewModel.GetGenders{ [weak self]state in
//            guard let self = self, let state = state else{
//                return
//            }
//            
//            switch state {
//            case .loading:
////                Hud.showHud(in: self.view)
//                print("")
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
//                Hud.dismiss(from: self.view)
//                print(state)
//            case .error(_,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
    
    func SendJoinRequest(){
        ViewModel.name = TFName.text
        ViewModel.mobile = TFPhone.text
//        ViewModel.districtId = DistrictId
//        ViewModel.genderId = GenderId
//        ViewModel.pharmacyCode = TFCode.text ?? "" 
        
        ViewModel.SignUp{[weak self] state in
            guard let self = self,let state = state else{
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
                JoinRequestSent()
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    
//    func SetDropDown(DropListSource: String ){
//        switch DropListSource {
//            
//        case "Gender":
//            if let dataArray = ViewModel.GendersArr{
//                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
//            }
//            rightBarDropDown.anchorView = TFPassword
//            let preferredViewWidth = TFPassword.frame.size.width // Assuming ViewPreferred is a UIView
//            rightBarDropDown.width = preferredViewWidth
//            ViewPasswordConfirm.borderColor = UIColor(named: "stroke")
//            TFPasswordConfirm.textColor = UIColor(named: "main")
//            //            ViewGender.backgroundColor = .white
//            BtnPasswordConfirm.isSelected = true
//            
//        case "District":
//            if let dataArray = ViewModel.DistrictsArr{
//                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
//            }
//            rightBarDropDown.anchorView = TFDistrict
//            let preferredViewWidth = TFDistrict.frame.size.width // Assuming ViewPreferred is a UIView
//            rightBarDropDown.width = preferredViewWidth
//            ViewDistrict.borderColor = UIColor(named: "stroke")
//            TFDistrict.textColor = UIColor(named: "main")
//            //            ViewDistrict.backgroundColor = .white
//            BtnDistrict.isSelected = true
//            
//        default:
//            print("")
//        }
//        
//        rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)
//        rightBarDropDown.show()
//        
//        
//        
//        rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//            switch DropListSource {
//            case "Gender":
//                self.TFGender.text = ViewModel.GendersArr?[index].title
//                self.GenderId = ViewModel.GendersArr?[index].id
//                BtnGender.isSelected = false
//                
//                let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
//                let isNameValid = TFName.hasText // Check if TFPassword is not empty
////                let isCodeValid = TFCode.hasText // Check if TFCode is not empty
//                let isDestrictValid = DistrictId != nil
//                let isGenderValid = GenderId != nil
//                
//                let isValidForm = isPhoneValid && isNameValid && isDestrictValid && isGenderValid
//                BtnRegister.enable(isValidForm)
//                
//            case "District":
//                self.TFDistrict.text = ViewModel.DistrictsArr?[index].title
//                self.DistrictId = ViewModel.DistrictsArr?[index].id
//                BtnDistrict.isSelected = false
//                
//                
//                let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
//                let isNameValid = TFName.hasText // Check if TFPassword is not empty
////                let isCodeValid = TFCode.hasText // Check if TFCode is not empty
//                let isDestrictValid = DistrictId != nil
//                let isGenderValid = GenderId != nil
//                
//                let isValidForm = isPhoneValid && isNameValid && isDestrictValid && isGenderValid
//                BtnRegister.enable(isValidForm)
//                
//            default:
//                print("")
//            }
//        }
//    }
    
    func JoinRequestSent()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم إرسال طلب انضمامك بنجاح"
            viewDone.imgStr = "keyicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
            }
        }
    }
}
