//
//  SignUp.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import DropDown

enum DrobListSource{
case Gender,District
}
class SignUp: UIViewController  , UITextFieldDelegate{
    
    @IBOutlet weak var TFName: UITextField!
    @IBOutlet weak var ViewName: UIView!
    @IBOutlet weak var BtnName: UIView!
    
    @IBOutlet weak var TFPhone: UITextField!
    @IBOutlet weak var ViewPhoneNum: UIView!
    @IBOutlet weak var BtnPhone: UIView!
    
    @IBOutlet weak var TFDistrict: UITextField!
    @IBOutlet weak var ViewDistrict: UIView!
    @IBOutlet weak var BtnDistrict: UIButton!
    var DistrictId: Int?
    
    @IBOutlet weak var TFGender: UITextField!
    @IBOutlet weak var ViewGender: UIView!
    @IBOutlet weak var BtnGender: UIButton!
    var GenderId: Int?
    
    @IBOutlet weak var TFCode: UITextField!
    @IBOutlet weak var ViewCode: UIView!
    @IBOutlet weak var BtnCode: UIView!
    
    @IBOutlet weak var BtnRegister: UIButton!
//    let dataArray = ["الدمام", "مكة", "الرياض", "بريدة", "القصيم"]
        let rightBarDropDown = DropDown()
    
    let ViewModel = SignUpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TFName.delegate = self
        BtnName.isHidden = true
        
        TFPhone.delegate = self
        BtnPhone.isHidden = true
        
        TFCode.delegate = self
        BtnCode.isHidden = true
        
        TFName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFCode.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFDistrict.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        TFGender.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        TFDistrict.delegate = self
        TFGender.delegate = self

        BtnRegister.enable(false)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            self.getDistricts()
            self.getGenders()
        }
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BULogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BUSignUp(_ sender: Any) {
        SendJoinRequest()
    }
    
    @IBAction func BUSelectDistrict(_ sender: Any) {
        SetDropDown(DropListSource: .District)
        }
    @IBAction func showDestrict(_ sender: Any) {
        SetDropDown(DropListSource: .District)
    }
    
    @IBAction func BUSelectGender(_ sender: Any) {
       SetDropDown(DropListSource: .Gender)
       }
    @IBAction func showGender(_ sender: Any) {
        SetDropDown(DropListSource: .Gender)
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
        }else if textField == TFDistrict{
            ViewDistrict.borderColor = UIColor(named: "stroke")
        }else if textField == TFDistrict{
            ViewGender.borderColor = UIColor(named: "stroke")
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
            
        } else  if textField == TFCode {
            if TFCode.text?.count == 0 {
                BtnCode.isHidden = true
            } else {
                BtnCode.isHidden = false
            }
        } else {
        }
        
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isPhoneValid = TFPhone.text?.count == 11 // Check if TFPhone has 11 digits
        let isNameValid = TFName.hasText // Check if TFPassword is not empty
        let isCodeValid = TFCode.hasText // Check if TFCode is not empty
        let isDestrictValid = DistrictId != nil
        let isGenderValid = GenderId != nil

        let isValidForm = isPhoneValid && isNameValid && isDestrictValid && isGenderValid && isCodeValid
        BtnRegister.enable(isValidForm)
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
        } else if textField == TFGender ||  textField == TFDistrict {
            return false
        }
        return true
    }
    
}

//MARK: ---- functions -----
extension SignUp{
    func getDistricts(){
        ViewModel.GetDistricts{ [weak self] state in
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
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    func getGenders(){
        ViewModel.GetGenders{ [weak self]state in
            guard let self = self, let state = state else{
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
            case .error(_,let error):
                Hud.dismiss(from: self.view)
                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
                print(error ?? "")
            case .none:
                print("")
            }
        }
    }
    func SendJoinRequest(){
        ViewModel.name = TFName.text
        ViewModel.mobile = TFPhone.text
        ViewModel.districtId = DistrictId
        ViewModel.genderId = GenderId
        ViewModel.pharmacyCode = TFCode.text
        
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
     
    func SetDropDown(DropListSource:DrobListSource){
        switch DropListSource{
        case .Gender:
            if let dataArray = ViewModel.GendersArr{
                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
            }
            rightBarDropDown.anchorView = TFGender
            let preferredViewWidth = TFGender.frame.size.width // Assuming ViewPreferred is a UIView
            rightBarDropDown.width = preferredViewWidth
            ViewGender.borderColor = UIColor(named: "stroke")
            TFGender.textColor = UIColor(named: "main")
//            ViewGender.backgroundColor = .white
            BtnGender.isSelected = true

        case .District:
            if let dataArray = ViewModel.DistrictsArr{
                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
            }
            rightBarDropDown.anchorView = TFDistrict
            let preferredViewWidth = TFDistrict.frame.size.width // Assuming ViewPreferred is a UIView
            rightBarDropDown.width = preferredViewWidth
            ViewDistrict.borderColor = UIColor(named: "stroke")
            TFDistrict.textColor = UIColor(named: "main")
//            ViewDistrict.backgroundColor = .white
            BtnDistrict.isSelected = true

        }
        rightBarDropDown.bottomOffset = CGPoint(x: -10 , y: (rightBarDropDown.anchorView?.plainView.bounds.height)!)

        rightBarDropDown.selectionAction = { [self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            switch DropListSource {
            case .Gender:
                self.TFGender.text = ViewModel.GendersArr?[index].title
                self.GenderId = ViewModel.GendersArr?[index].id
                BtnGender.isSelected = false

            case .District:
                self.TFDistrict.text = ViewModel.DistrictsArr?[index].title
                self.DistrictId = ViewModel.DistrictsArr?[index].id
                BtnDistrict.isSelected = false

            }
        }
                //        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
                rightBarDropDown.cancelAction = { [self] in
                    switch DropListSource {
                    case .Gender:
                        BtnGender.isSelected = false
                        if TFGender.text == "" {
                        ViewDistrict.borderColor = UIColor(named: "stroke")

//                            ViewGender.backgroundColor = UIColor(named: "F5F5F5")
                        }
                    case .District:
                        BtnDistrict.isSelected = false
                        if TFDistrict.text == "" {
                            ViewDistrict.borderColor     = UIColor(named: "stroke")
//                            ViewDistrict.backgroundColor = UIColor(named: "F5F5F5")
                        }
                    }
                }
        rightBarDropDown.show()
    }
    
    func JoinRequestSent()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم إرسال طلب انضمامك بنجاح"
            viewDone.imgStr = "keyicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
                Helper.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
            }
        }
    }
}
