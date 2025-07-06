//import UIKit
import SwiftUI

//class ChangePasswordVC: UIViewController {
//    
//    @IBOutlet weak var LaNavTitle: UILabel!
//    @IBOutlet weak var TFPassword: CustomInputField!
//    @IBOutlet weak var TFNewPassword: CustomInputField!
//    @IBOutlet weak var TFRe_Password: CustomInputField!
//    @IBOutlet weak var BtnChange: UIButton!
//    
//    @IBOutlet weak var BtnBack: UIButton!
//    
//    let ViewModel = ChangePasswordVM()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupPasswordValidations()
//    }
//    
//    func setupUI(){
//        BtnChange.isEnabled(false)
//        hideKeyboardWhenTappedAround()
//
//        LaNavTitle.text = "change_sc_title".localized
//
//        BtnChange.setTitle("change_sc_btn_title".localized(with: "Localizable"), for: .normal)
//        BtnBack.setImage(UIImage(resource:.backLeft).flippedIfRTL, for: .normal)
//    }
//
//    private func setupPasswordValidations() {
//        // Set minimum 6 characters for old password
//        TFPassword.validationRule = { text in
//            guard let text = text else { return false }
//            return text.count >= 6
//        }
//        
//        // Set minimum 6 characters for password
//        TFNewPassword.validationRule = { text in
//            guard let text = text else { return false }
//            return text.count >= 6
//        }
//        
//        // Set confirmation must match password and have 6+ chars
//        TFRe_Password.validationRule = { [weak self] text in
//            guard let self = self, let text = text else { return false }
//            return text.count >= 6 && text == self.TFNewPassword.text()
//        }
//        
//        // Handle validation changes
//        [TFPassword,TFNewPassword,TFRe_Password].forEach{$0.onValidationChanged = { [weak self] isValid in
//            self?.validateForm()
//        }}
//    }
//    
//    private func validateForm() {
//        let isPasswordValid = TFPassword.textField.hasText && TFPassword.isValid
//        let isNewPasswordValid = TFNewPassword.textField.hasText && TFNewPassword.isValid
//        let isConfirmationValid = TFRe_Password.textField.hasText && TFRe_Password.isValid
//        
//        BtnChange.isEnabled(isPasswordValid && isNewPasswordValid && isConfirmationValid)
//        if (isPasswordValid && isNewPasswordValid && isConfirmationValid){
//            applyHorizontalGradient(to: BtnChange)
//        }
//    }
//    @IBAction func BUBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func BUChange(_ sender: Any) {
//        ChangePassword()
//    }
//    
//}

//extension ChangePasswordVC {
//    func ChangePassword(){
//        ViewModel.oldPassword = TFPassword.text()
//        ViewModel.newPassword = TFRe_Password.text()
//        
//        ViewModel.ChangePassword{[weak self] state in
//            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            switch state {
//            case .loading:
//                Hud.showHud(in: self.view)
//            case .stopLoading:
//                Hud.dismiss(from: self.view)
//            case .success:
//                Hud.dismiss(from: self.view)
//                print(state)
//                PassChangedDone()
//            case .error(_,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self)
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    func PassChangedDone()  {
//        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
//            viewDone.title = "changed_title"
//            viewDone.subtitle1 = "changed_subtitle1"
//            viewDone.subtitle2 = "changed_subtitle2"
//            viewDone.ButtonTitle = "changed_btn"
//            
//            viewDone.imgStr = "successicon"
//            viewDone.action = {
//                viewDone.removeFromSuperview()
////                self.navigationController?.popViewController(animated: true)
////                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
//                let newHome = UIHostingController(rootView: LoginView())
//                Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
//
//            }
//        }
//    }
//}


struct ChangePasswordView: View {
    @State private var oldPassword = ""

    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @State private var isoldPasswordValid = true
    @State private var isNewPasswordValid = true
    @State private var isConfirmPasswordValid = true

    @StateObject private var viewModel = ChangePasswordVM()
    
    var body: some View {
        VStack(spacing: 20) {
            TitleBar(title: "change_sc_title", hasbackBtn: true)
                .padding(.top)
            
            VStack (spacing: 20){
//                Text("change_sc_subtitle".localized)
//                    .font(.medium(size: 18))
//                    .foregroundColor(Color(.secondary))
//                    .padding(.top)
//                    .padding(.vertical, 40)
                
                Spacer().frame(height: 40)

                CustomInputFieldUI(
                    title: "change_sc_oldpass_title",
                    placeholder: "change_sc_oldpass_placeholder",
                    text: $oldPassword,
                    isSecure: true,
                    showToggle: true,
                    isValid: isoldPasswordValid
                )
                .onChange(of: oldPassword) { value in
                    isoldPasswordValid =  value.count == 0 || value.count >= 6
//                    isoldPasswordValid = oldPassword.count >= 6
                }
                
                CustomInputFieldUI(
                    title: "change_sc_pass_title",
                    placeholder: "change_sc_pass_placeholder",
                    text: $newPassword,
                    isSecure: true,
                    showToggle: true,
                    isValid: isNewPasswordValid
                )
                .onChange(of: newPassword) { value in
                    isNewPasswordValid = value.count == 0 || (value.count >= 6)
                    isConfirmPasswordValid = confirmPassword.count >= 6 && confirmPassword == newPassword
                }
                
                CustomInputFieldUI(
                    title: "change_sc_repass_title",
                    placeholder: "change_sc_repass_placeholder",
                    text: $confirmPassword,
                    isSecure: true,
                    showToggle: true,
                    isValid: isConfirmPasswordValid
                )
                .onChange(of: confirmPassword) { value in
                    isConfirmPasswordValid = value.count == 0 || (value.count >= 6 && value == newPassword)
                }
                
                Spacer()
                
                CustomButtonUI(title: "change_sc_btn_title", isValid: isFormValid) {
                    changePassword()
                }
            }
            .padding(.horizontal)
        }
        .localizeView()
        .showHud2(isShowing: $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .onChange(of: viewModel.isSuccess ){newval in
        guard newval else { return }
            PassChangedDone()
        }
    }
    private var isFormValid: Bool {
        (oldPassword.count > 0 && isoldPasswordValid)
        && (newPassword.count > 0 && isNewPasswordValid)
        && (confirmPassword.count > 0 && isConfirmPasswordValid)
//        && (newPassword == isConfirmPasswordValid)
    }
    func changePassword() {
        guard isFormValid else { return }
        viewModel.oldPassword = oldPassword
        viewModel.newPassword = confirmPassword
        viewModel.changePassword()
    }

//    func handleChangePasswordState() {
//        guard let state = state else { return }
//        switch state {
//        case .loading:
//            Hud.showHud()
//        case .stopLoading:
//            Hud.dismiss()
//        case .success:
//            Hud.dismiss()
//            if let viewDone: ViewDone = showView(fromNib: ViewDone.self) {
//                viewDone.title = "changed_title"
//                viewDone.subtitle1 = "changed_subtitle1"
//                viewDone.subtitle2 = "changed_subtitle2"
//                viewDone.ButtonTitle = "changed_btn"
//                viewDone.imgStr = "successicon"
//                viewDone.action = {
//                    viewDone.removeFromSuperview()
//                    let newHome = UIHostingController(rootView: LoginView())
//                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
//                }
//            }
//        case .error(_, let error):
//            Hud.dismiss()
//            SimpleAlert.shared.showAlert(title: error ?? "", message: "")
//        case .none:
//            break
//        }
//    }
    
    func PassChangedDone() {
            let successView = SuccessView(
                image: Image("successicon"),
                title: "changed_title".localized,
                subtitle1: "changed_subtitle1".localized,
                subtitle2: "changed_subtitle2".localized,
                buttonTitle: "changed_btn".localized,
                buttonAction: {
                    // Navigate to home or login
                    let login = UIHostingController(rootView: LoginView())
                    Helper.shared.changeRootVC(newroot: login, transitionFrom: .fromLeft)
                }
            )
            let newVC = UIHostingController(rootView: successView)
            Helper.shared.changeRootVC(newroot: newVC, transitionFrom: .fromLeft)
            
    }
}
