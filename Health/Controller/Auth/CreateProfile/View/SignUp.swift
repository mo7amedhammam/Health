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
            rightBarDropDown.show()
        }
    
    @IBAction func BUSelectGender(_ sender: Any) {
       SetDropDown(DropListSource: .Gender)
           rightBarDropDown.show()
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
            ViewGender.borderColor = UIColor(named: "main")
            ViewGender.backgroundColor = .white
            BtnGender.isSelected = true

        case .District:
            if let dataArray = ViewModel.DistrictsArr{
                rightBarDropDown.dataSource = dataArray.compactMap{$0.title}
            }
            rightBarDropDown.anchorView = TFDistrict
            let preferredViewWidth = TFDistrict.frame.size.width // Assuming ViewPreferred is a UIView
            rightBarDropDown.width = preferredViewWidth
            ViewDistrict.borderColor = UIColor(named: "main")
            ViewDistrict.backgroundColor = .white
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
                            ViewGender.borderColor     = UIColor(named: "F0F0F0")
                            ViewGender.backgroundColor = UIColor(named: "F5F5F5")
                        }
                    case .District:
                        BtnDistrict.isSelected = false
                        if TFDistrict.text == "" {
                            ViewDistrict.borderColor     = UIColor(named: "F0F0F0")
                            ViewDistrict.backgroundColor = UIColor(named: "F5F5F5")
                        }
                    }
                    
                }
    }
    
    func JoinRequestSent()  {
        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
            viewDone.title = "تم إرسال طلب انضمامك بنجاح"
            viewDone.imgStr = "keyicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
                Helper.changeRootVC(newroot: LoginVC.self)
            }
        }
    }
}
