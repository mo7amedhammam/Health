//
//  ChangePasswordVC.swift
//  Health
//
//  Created by Hamza on 29/07/2023.
//

import UIKit
import SwiftUI

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var LaNavTitle: UILabel!
    @IBOutlet weak var TFPassword: CustomInputField!
    @IBOutlet weak var TFNewPassword: CustomInputField!
    @IBOutlet weak var TFRe_Password: CustomInputField!
    @IBOutlet weak var BtnChange: UIButton!
    
    @IBOutlet weak var BtnBack: UIButton!
    
    let ViewModel = ChangePasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPasswordValidations()
    }
    
    func setupUI(){
        BtnChange.isEnabled(false)
        hideKeyboardWhenTappedAround()

        LaNavTitle.text = "change_sc_title".localized

        BtnChange.setTitle("change_sc_btn_title".localized(with: "Localizable"), for: .normal)
        BtnBack.setImage(UIImage(resource:.backLeft).flippedIfRTL, for: .normal)
    }

    private func setupPasswordValidations() {
        // Set minimum 6 characters for old password
        TFPassword.validationRule = { text in
            guard let text = text else { return false }
            return text.count >= 6
        }
        
        // Set minimum 6 characters for password
        TFNewPassword.validationRule = { text in
            guard let text = text else { return false }
            return text.count >= 6
        }
        
        // Set confirmation must match password and have 6+ chars
        TFRe_Password.validationRule = { [weak self] text in
            guard let self = self, let text = text else { return false }
            return text.count >= 6 && text == self.TFNewPassword.text()
        }
        
        // Handle validation changes
        [TFPassword,TFNewPassword,TFRe_Password].forEach{$0.onValidationChanged = { [weak self] isValid in
            self?.validateForm()
        }}
    }
    
    private func validateForm() {
        let isPasswordValid = TFPassword.textField.hasText && TFPassword.isValid
        let isNewPasswordValid = TFNewPassword.textField.hasText && TFNewPassword.isValid
        let isConfirmationValid = TFRe_Password.textField.hasText && TFRe_Password.isValid
        
        BtnChange.isEnabled(isPasswordValid && isNewPasswordValid && isConfirmationValid)
        if (isPasswordValid && isNewPasswordValid && isConfirmationValid){
            applyHorizontalGradient(to: BtnChange)
        }
    }
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BUChange(_ sender: Any) {
        ChangePassword()
    }
    
}

extension ChangePasswordVC {
    func ChangePassword(){
        ViewModel.oldPassword = TFPassword.text()
        ViewModel.newPassword = TFRe_Password.text()
        
        ViewModel.ChangePassword{[weak self] state in
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
            viewDone.title = "changed_title"
            viewDone.subtitle1 = "changed_subtitle1"
            viewDone.subtitle2 = "changed_subtitle2"
            viewDone.ButtonTitle = "changed_btn"
            
            viewDone.imgStr = "successicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
//                self.navigationController?.popViewController(animated: true)
//                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                let newHome = UIHostingController(rootView: LoginView())
                Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)

            }
        }
    }
}
