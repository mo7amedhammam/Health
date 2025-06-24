//
//  ForgetPasswordVC.swift
//  Health
//
//  Created by Hamza on 27/07/2023.
//

import UIKit
import SwiftUI

class ForgetPasswordVC: UIViewController  , UIGestureRecognizerDelegate {
    @IBOutlet weak var LaNavTitle: UILabel!
    
    @IBOutlet weak var LaSubtitle: UILabel!
    
    @IBOutlet weak var TFPassword: CustomInputField!
    @IBOutlet weak var TFRe_Password: CustomInputField!
    
    @IBOutlet weak var BtnReset: UIButton!
    @IBOutlet weak var BtnBack: UIButton!
    var Phonenumber : String?
    let ViewModel = ForgetPasswordVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        hideKeyboardWhenTappedAround()
        setupPasswordValidations()

    }
    
    func setupUI(){
        BtnReset.isEnabled(false)

        LaNavTitle.text = "forget_title".localized
        LaSubtitle.text = "forget_subtitle".localized

        BtnReset.setTitle("forget_btn_title".localized(with: "Localizable"), for: .normal)
        BtnBack.setImage(UIImage(resource:.backLeft).flippedIfRTL, for: .normal)
        LaSubtitle.font = UIFont(name: fontsenum.medium.rawValue, size: 16)
    }
    private func setupPasswordValidations() {
        // Set minimum 6 characters for password
        TFPassword.validationRule = { text in
            guard let text = text else { return false }
            return text.count >= 6
        }
        
        // Set confirmation must match password and have 6+ chars
        TFRe_Password.validationRule = { [weak self] text in
            guard let self = self, let text = text else { return false }
            return text.count >= 6 && text == self.TFPassword.text()
        }
        
        // Handle validation changes
        [TFPassword,TFRe_Password].forEach{$0.onValidationChanged = { [weak self] isValid in
            self?.validateForm()
        }}
    }
    
    private func validateForm() {
        let isPasswordValid = TFPassword.textField.hasText && TFPassword.isValid
        let isConfirmationValid = TFRe_Password.textField.hasText && TFRe_Password.isValid
        
        BtnReset.isEnabled(isPasswordValid && isConfirmationValid)
        if (isPasswordValid && isConfirmationValid) {
            applyHorizontalGradient(to: BtnReset)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @IBAction func BURe_Set(_ sender: Any) {
        ResetPassword()
    }
    
    @IBAction func BUBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ForgetPasswordVC {
    func ResetPassword(){
        ViewModel.mobile = Phonenumber
        ViewModel.newPassword = TFPassword.text()
        
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
            viewDone.title = "reset_title"
            viewDone.subtitle1 = "reset_subtitle1"
            viewDone.subtitle2 = "reset_subtitle2"
            viewDone.ButtonTitle = "reset_btn"

            viewDone.imgStr = "successicon"
            viewDone.action = {
                viewDone.removeFromSuperview()
//                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
                let newHome = UIHostingController(rootView: LoginView())
                Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)

            }
        }
    }
}

