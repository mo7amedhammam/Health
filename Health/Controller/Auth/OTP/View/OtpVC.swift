//
//  OtpVC.swift
//  Health
//
//  Created by Hamza on 29/07/2023.
//

import UIKit
import SwiftUI

enum otpCases {
case CreateAccount , forgetPassword
}
//class OtpVC: UIViewController , UITextFieldDelegate {
//    
//    @IBOutlet weak var NavBarView: UIView!
//
//    @IBOutlet weak var LaToMessage: UILabel!
//    @IBOutlet weak var LaToNum: UILabel!
//    
//    @IBOutlet weak var STMsgSent: UIStackView!
//    
//    @IBOutlet weak var TFIndex1: UITextField!
//    @IBOutlet weak var TFIndex2: UITextField!
//    @IBOutlet weak var TFIndex3: UITextField!
//    @IBOutlet weak var TFIndex4: UITextField!
//    @IBOutlet weak var TFIndex5: UITextField!
//    @IBOutlet weak var TFIndex6: UITextField!
//
//    @IBOutlet weak var ViewTF1: UIView!
//    @IBOutlet weak var ViewTF2: UIView!
//    @IBOutlet weak var ViewTF3: UIView!
//    @IBOutlet weak var ViewTF4: UIView!
//    @IBOutlet weak var ViewTF5: UIView!
//    @IBOutlet weak var ViewTF6: UIView!
//    @IBOutlet weak var STOTP: UIStackView!
//    
//    @IBOutlet weak var DidntGetCode: UILabel!
//    @IBOutlet weak var BtnResend: UIButton!
//    @IBOutlet weak var STReseend: UIStackView!
//    var Phonenumber:String?
//    
//    @IBOutlet weak var SecondsCount: UILabel!
//    @IBOutlet weak var LaSeconds: UILabel!
//    @IBOutlet weak var STRemainigSec: UIStackView!
//
//    @IBOutlet weak var ShowOtp: UILabel!
//
//    @IBOutlet weak var BtnBack: UIButton!
//    var timer: Timer?
//    var second = 0
//    var otp    = 0
//    var verivyFor:otpCases = .CreateAccount
//    let viewModel = OtpVM()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        SetupUI()
//        clearOtp()
//        startTimer(remainingSeconds: second)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        RefreshLocalization()
//        TFIndex1.becomeFirstResponder()
////        clearOtp()
////        startTimer(remainingSeconds: second)
////        ShowOtp.text = otp
//        
//        timer?.invalidate()
//        timer = nil
//        
//        if second > 0 {
//            startTimer(remainingSeconds: second)
//        } else {
//            // Time's up, enable the button and invalidate the timer
//            SecondsCount.text = ""
//            canResend(true)
//        }
//        
//    }
//            
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        timer?.invalidate()
//        timer = nil
//        
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    func SetupUI(){
////        ShowOtp.text = String(otp)
//        BtnBack.setImage(UIImage(resource: .backRight).flippedIfRTL, for: .normal)
//
//        hideKeyboardWhenTappedAround()
////        LaToNum.localized(string: Phonenumber ?? "")
//
//        // Do any additional setup after loading the view.
//        self.TFIndex1.delegate = self
//        self.TFIndex2.delegate = self
//        self.TFIndex3.delegate = self
//        self.TFIndex4.delegate = self
//        self.TFIndex5.delegate = self
//        self.TFIndex6.delegate = self
//
//        // Text Field Action
//        self.TFIndex1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        self.TFIndex2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        self.TFIndex3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        self.TFIndex4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        self.TFIndex5.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//        self.TFIndex6.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
//    }
//    func RefreshLocalization(){
//        let isRTL = Helper.shared.getLanguage() == "ar"
//        
//        [LaToNum,BtnResend,LaToNum,LaSeconds].forEach{view in
//            view?.localizedview()
//        }
//        let otpmsg = "code_sentmsg".localized + " \((Phonenumber ?? ""))"
//        LaToMessage.text =  otpmsg
////        STOTP.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
//        DidntGetCode.reverselocalized(string: "didnt_get_code")
//        BtnResend.setTitle("resend_code".localized, for: .normal)
////        BtnResend.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
//        BtnResend.contentHorizontalAlignment = .leading
//
//        LaSeconds.reverselocalized(string: "remain_sec")
//        SecondsCount.reverselocalizedview()
//        LaSeconds.textAlignment = isRTL ? .right : .left
//        ShowOtp.text = "استخدم ".localized + "\(otp)"
//        LaToNum.localized(string: "")
//        
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//    }
//    
//    @IBAction func BUBack(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//          if textField == TFIndex1 {
//              TFIndex1.text = ""
//              TFIndex1.textColor = UIColor(named: "main")
//              ViewTF1.backgroundColor = .white
//          } else if textField == TFIndex2 {
//              TFIndex2.text = ""
//              TFIndex2.textColor = UIColor(named: "main")
//              ViewTF2.backgroundColor = .white
//          } else if textField == TFIndex3 {
//              TFIndex3.text = ""
//              TFIndex3.textColor = UIColor(named: "main")
//              ViewTF3.backgroundColor = .white
//          } else if textField == TFIndex4 {
//              TFIndex4.text = ""
//              TFIndex4.textColor = UIColor(named: "main")
//              ViewTF4.backgroundColor = .white
//          } else if textField == TFIndex5 {
//              TFIndex5.text = ""
//              TFIndex5.textColor = UIColor(named: "main")
//              ViewTF5.backgroundColor = .white
//          } else if textField == TFIndex6 {
//              TFIndex6.text = ""
//              TFIndex6.textColor = UIColor(named: "main")
//              ViewTF6.backgroundColor = .white
//          } else {
//          }
//      }
//    
//    @objc func textFieldDidChange(textField: UITextField){
//        
//        let text = textField.text
//        if text?.utf16.count == 1 {
//            switch textField{
//            case self.TFIndex1:
//                if !TFIndex1.text!.isEmpty {
//                    TFIndex1.textColor = UIColor(named: "main")
////                    ViewTF1.backgroundColor = UIColor(named: "main")
//                    self.TFIndex2.becomeFirstResponder()
//                } else {
//                    ViewTF1.backgroundColor = .clear
//                }
//                
//                
//            case self.TFIndex2:
//                if !TFIndex2.text!.isEmpty {
//                    TFIndex2.textColor = UIColor(named: "main")
////                    ViewTF2.backgroundColor = UIColor(named: "main")
//                    self.TFIndex3.becomeFirstResponder()
//                } else {
//                    ViewTF2.backgroundColor = .clear
//                }
//
//            case self.TFIndex3:
//                if !TFIndex3.text!.isEmpty {
//                    TFIndex3.textColor = UIColor(named: "main")
////                    ViewTF3.backgroundColor = UIColor(named: "main")
//                    self.TFIndex4.becomeFirstResponder()
//                } else {
//                    ViewTF3.backgroundColor = .clear
//                }
// 
//            case self.TFIndex4:
//                if !TFIndex4.text!.isEmpty {
//                    TFIndex4.textColor = UIColor(named: "main")
////                    ViewTF4.backgroundColor = UIColor(named: "main")
//                    self.TFIndex5.becomeFirstResponder()
//                } else {
//                    ViewTF4.backgroundColor = .clear
//                }
//            case self.TFIndex5:
//                if !TFIndex5.text!.isEmpty {
//                    TFIndex5.textColor = UIColor(named: "main")
////                    ViewTF5.backgroundColor = UIColor(named: "main")
//                    self.TFIndex6.becomeFirstResponder()
//                } else {
//                    ViewTF5.backgroundColor = .clear
//                }
//
//            case self.TFIndex6:
//                if !TFIndex6.text!.isEmpty {
//                    TFIndex6.textColor = UIColor(named: "main")
////                    ViewTF6.backgroundColor = UIColor(named: "main")
//                    
//                    //Make verification action when complete 6 digits
//                    VerifyOtp()
//                } else {
//                    ViewTF6.backgroundColor = .clear
//                }
//        
//            default:
//                break
//            }
//        } else {
//
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        if TFIndex1.text == "" {
//            ViewTF1.backgroundColor = .clear
//        }
//        
//        if TFIndex2.text == "" {
//            ViewTF2.backgroundColor = .clear
//        }
//        
//        if TFIndex3.text == "" {
//            ViewTF3.backgroundColor = .clear
//        }
//        
//        if TFIndex4.text == "" {
//            ViewTF4.backgroundColor = .clear
//        }
//        
//        if TFIndex5.text == "" {
//            ViewTF5.backgroundColor = .clear
//        }
//        
//        if TFIndex6.text == "" {
//            ViewTF6.backgroundColor = .clear
//        }
//
//    }
//    
//    @IBAction func BUResend(_ sender: Any) {
//        SendOtp()
//    }
//    
//    @IBAction func BUConfirm(_ sender: Any) {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let vc = storyboard.instantiateViewController(withIdentifier: "HTBC") as! HTBC
////        vc.modalPresentationStyle = .fullScreen
////        self.present(vc, animated: false, completion: nil)
//    }
//    fileprivate func canResend( _ canResend:Bool) {
//        self.BtnResend.isEnabled = canResend
//        self.BtnResend.alpha     = canResend ? 1 : 0.7
//    }
//}


//MARK: ---- functions -----
//extension OtpVC{
//    
//    func SendOtp() {
//        viewModel.mobile = Phonenumber
//        
//        viewModel.SendOtp{[weak self] state in
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
//            clearOtp()
//                guard let seconds = viewModel.responseModel?.secondsCount else {return}
//                startTimer(remainingSeconds: seconds)
////                Shared.shared.remainingSeconds = seconds
//                ShowOtp.text = "استخدم \(viewModel.responseModel?.otp ?? 00)"
//            case .error(let code,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion:{
//                    if code == 400 {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                })
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    
//    func VerifyOtp() {
//        viewModel.mobile = Phonenumber
//        
//        guard let otp1 = TFIndex1.text ,let otp2 = TFIndex2.text,let otp3 = TFIndex3.text,let otp4 = TFIndex4.text,let otp5 = TFIndex5.text,let otp6 = TFIndex6.text else {return}
//        let fullotp = otp1+otp2+otp3+otp4+otp5+otp6
//        viewModel.EnteredOtp = fullotp
//        viewModel.VerifyOtp(otpfor: verivyFor){[weak self] state in
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
//                switch verivyFor {
//                case .CreateAccount:
//                    // got to success creating account
//                    accountCreated()
//                case .forgetPassword:
//                    gotoResetPassword()
//                }
//            case .error(_,let error):
//                Hud.dismiss(from: self.view)
//                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion: {
//                    self.clearOtp()
//                })
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    
//    private func gotoResetPassword(){
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: ForgetPasswordVC.self) else{return}
//        vc.Phonenumber = Phonenumber
//         navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func accountCreated()  {
//        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
//            viewDone.title = "created_title"
//            viewDone.subtitle1 = "created_subtitle1"
//            viewDone.subtitle2 = "created_subtitle2"
//            viewDone.ButtonTitle = "created_btn"
//
//            viewDone.imgStr = "successicon"
//            viewDone.action = {
//                viewDone.removeFromSuperview()
//                self.navigationController?.popViewController(animated: true)
////                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
//                let newHome = UIHostingController(rootView: LoginView())
//                Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
//
//            }
//        }
//    }
//    
//    private func clearOtp(){
//        TFIndex1.text = ""
//        ViewTF1.backgroundColor = .clear
//        TFIndex1.becomeFirstResponder()
//        
//        TFIndex2.text = ""
//        ViewTF2.backgroundColor = .clear
//
//        TFIndex3.text = ""
//        ViewTF3.backgroundColor = .clear
//
//        TFIndex4.text = ""
//        ViewTF4.backgroundColor = .clear
//
//        TFIndex5.text = ""
//        ViewTF5.backgroundColor = .clear
//
//        TFIndex6.text = ""
//        ViewTF6.backgroundColor = .clear
//        
//    }
//    
//    func startTimer(remainingSeconds:Int) {
//        timer?.invalidate()
//        canResend(false)
//
//        var remainingSeconds = remainingSeconds
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//            guard let self = self else { return }
//                        
//            if remainingSeconds > 0 {
//                remainingSeconds -= 1
//                self.SecondsCount.reverselocalized(string: "\(timeString(time: TimeInterval(remainingSeconds))) ")
////                self.SecondsCount.text = "\(timeString(time: TimeInterval(remainingSeconds))) "
//                // Still have time, enable the button and invalidate the timer
//                canResend(false)
//
////                Shared.shared.remainingSeconds = remainingSeconds
////                print("Shared.shared.remainingSeconds :::::: \(Shared.shared.remainingSeconds)")
//
//            } else {
//                // Time's up, enable the button and invalidate the timer
//                canResend(true)
//
//                timer.invalidate()
//            }
//            // Check for background execution and request more time if needed
//                   if UIApplication.shared.applicationState == .background {
//                       self.scheduleBackgroundTask()
//                   }
//        }
//    }
// 
//    func timeString(time:TimeInterval) -> String {
//    let minutes = Int(time) / 60 % 60
//    let seconds = Int(time) % 60
//    return String(format:"%02i:%02i", minutes, seconds)
//    }
//    
//    func scheduleBackgroundTask() {
//        // Request additional background time if needed
//        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//        backgroundTask = UIApplication.shared.beginBackgroundTask {
//            // End the background task when it's complete
//            UIApplication.shared.endBackgroundTask(backgroundTask)
//            backgroundTask = .invalid
//        }
//        print("Perform your")
//            self.startTimer(remainingSeconds: second)
//        
//        
//        // Perform your background task here
//        // Make sure to end the background task when the task is complete
////        DispatchQueue.global().async {
////            // Your background task code goes here
////            print("background your")
////            // End the background task when it's complete
////            UIApplication.shared.endBackgroundTask(backgroundTask)
////            backgroundTask = .invalid
////        }
//    }
//}

extension UIView{
    func localizedview(){
        let isRTL = Helper.shared.getLanguage() == "ar"
//        let view = self
//        UIView.appearance().semanticContentAttribute = !isRTL ? .forceLeftToRight : .forceRightToLeft

        self.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        if let label = self as? UILabel {
            label.textAlignment = isRTL ? .right : .left
            //        return view
        }
        // Also flip the subviews' alignment if needed (e.g., UIStackView)
//        if let stack = self as? UIStackView {
//            stack.semanticContentAttribute = !isRTL ? .forceLeftToRight : .forceRightToLeft
//            
//            if !isRTL {
//                        // Reverse the order of arranged subviews for RTL
//                        let reversedSubviews = stack.arrangedSubviews.reversed()
//                        for view in reversedSubviews {
//                            stack.removeArrangedSubview(view)
//                            stack.addArrangedSubview(view)
//                        }
//                    }
//            
//        }
//        for subview in subviews {
//                  subview.localizedview()
//              }
    }
    func reverselocalizedview(){
        let isRTL = Helper.shared.getLanguage() == "en"
//        let view = self
//        UIView.appearance().semanticContentAttribute = !isRTL ? .forceLeftToRight : .forceRightToLeft

        self.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        if let label = self as? UILabel {
            label.textAlignment = isRTL ? .right : .left
            //        return view
        }
//        view = isRTL ? .left : .right
//        return view
        
        // Also flip the subviews' alignment if needed (e.g., UIStackView)
//        if let stack = self as? UIStackView {
//            stack.semanticContentAttribute = !isRTL ? .forceLeftToRight : .forceRightToLeft
//
//            if !isRTL {
//                        // Reverse the order of arranged subviews for RTL
//                        let reversedSubviews = stack.arrangedSubviews.reversed()
//                        for view in reversedSubviews {
//                            stack.removeArrangedSubview(view)
//                            stack.addArrangedSubview(view)
//                        }
//                    }
//
//        }
//        for subview in subviews {
//                  subview.localizedview()
//              }
    }
}
extension UILabel{
    func localized(string: String){
        let isRTL = Helper.shared.getLanguage() == "ar"
//        let view = self
        self.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        self.textAlignment = isRTL ? .right : .left
        self.text = string.localized
//        return self
        
    }
    func reverselocalized(string: String){
        let isRTL = Helper.shared.getLanguage() == "en"
//        let view = self
        self.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        self.textAlignment = isRTL ? .right : .left
        self.text = string.localized
//        return self
        
    }
}




struct OTPView: View {
//    @Environment(\.layoutDirection) var layoutDirection
    @StateObject var viewModel = OtpVM()

    @FocusState private var focusedIndex: Int?
    @State private var otpFields: [String] = Array(repeating: "", count: 6)

    @State var remainingSeconds = 60
    @State private var resendEnabled = false
    @State private var timer: Timer?
    @State var otp = 0

    var phone = "01000000004"
    var verivyFor: otpCases = .CreateAccount
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    @Environment(\.dismiss) private var dismiss
    @State var backToLogin: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            TitleBar(title: "main_title", hasbackBtn: true)
            
            ScrollView{
            Image(.otpVerify)
                .padding(.top)
            
            Text("code_sentmsg".localized + "\n \(phone)")
                .font(.medium(size: 18))
                .foregroundColor(Color(.secondary))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.top, 10)
            
            otpFieldsView
                .padding(.top, 10)
            
            resendView
                .padding(.top, 30)
            
            countdownView
            
            if otp != 0 {
                Text("try: \(otp)")
                    .foregroundColor(Color(.secondary))
            }
        }
            Spacer()
        }
        .onAppear {
            viewModel.mobile = phone
            focusedIndex = 0
            startTimer(from: remainingSeconds)
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: viewModel.isSuccess){newval in
            guard newval == true else { return }
            switch verivyFor {
            case .CreateAccount: accountCreated()
            case .forgetPassword: gotoResetPassword()
            }
        }
        .task(id: backToLogin) {
            guard backToLogin else { return }
            dismiss()
        }
        
        .localizeView()
        .showHud2(isShowing: $viewModel.isLoading)
        //        .showHud2(isShowing: .constant(true))
        .errorAlert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)

        NavigationLink( "", destination: destination, isActive: $isactive)

    }

    private var resendView: some View {
        HStack {
            Text("didnt_get_code".localized)
                .foregroundColor(Color(.secondary))

            Button("resend_code".localized) {
                SendOtp()
            }
            .foregroundColor(.mainBlue)
            .opacity(resendEnabled ? 1 : 0.5)
            .disabled(!resendEnabled)
        }
        .font(.medium(size: 18))
    }

    private var countdownView: some View {
        HStack {
            Text("remain_sec".localized)
                .foregroundColor(Color(.secondary))

//            Text(" \(remainingSeconds)")
            Text(formattedTime(seconds: remainingSeconds))

                .foregroundColor(.mainBlue)
        }
        .font(.medium(size: 18))
    }

    private var otpFieldsView: some View {
        HStack(spacing: 10) {
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $otpFields[index])
                    .font(.medium(size: 18))
                    .foregroundStyle(Color(.main))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 40, height: 40)
                    .focused($focusedIndex, equals: index)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.mainBlue, lineWidth: 1))
                    .onChange(of: otpFields[index]) { newValue in
                        handleTextChange(index: index, value: newValue)
                    }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
    private func handleTextChange(index: Int, value: String) {
        if value.count > 1 {
            otpFields[index] = String(value.prefix(1))
        }

        if !value.isEmpty {
            if index < 5 {
                focusedIndex = index + 1
            } else {
                focusedIndex = nil
                verifyOTP()
            }
        }
    }

    private func startTimer(from value: Int?) {
        timer?.invalidate()

        remainingSeconds = value ?? 2
        resendEnabled = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                resendEnabled = true
                timer?.invalidate()
            }
        }
    }
    func formattedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
//            .environment(\.layoutDirection, .rightToLeft) // test RTL
    }
}


extension OTPView {
    func SendOtp() {
        viewModel.SendOtp { state in
            guard let state = state else { return }
            switch state {
            case .success:
                clearOtp()
                otp = viewModel.responseModel?.otp ?? 0
                startTimer(from: viewModel.responseModel?.secondsCount)
            case .error(_, let message):
                viewModel.errorMessage = message
            default: break
            }
        }
    }

    func verifyOTP() {
        let code = otpFields.joined()
        guard code.count == 6 else { return }

        viewModel.EnteredOtp = code
        viewModel.VerifyOtp(otpfor: verivyFor)
//        { state in
//            guard let state = state else { return }
//            switch state {
//            case .success:
//                switch verivyFor {
//                case .CreateAccount: accountCreated()
//                case .forgetPassword: gotoResetPassword()
//                }
//            case .error(_, let message):
//                viewModel.errorMessage = message
//                clearOtp()
//            default: break
//            }
//        }
    }

    private func clearOtp() {
        otpFields = Array(repeating: "", count: 6)
        focusedIndex = 0
    }

    private func gotoResetPassword() {
        
pushTo(destination: ForgetPasswordView(phoneNumber: phone,backToLogin: $backToLogin))
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: ForgetPasswordVC.self) else { return }
//        vc.Phonenumber = phone
//        pushUIKitVC(vc)
    }

    private func accountCreated() {
        let successView = SuccessView(
            image: Image("successicon"),
            title: "created_title".localized,
            subtitle1: "created_subtitle1".localized,
            subtitle2: "created_subtitle2".localized,
            buttonTitle: "created_btn".localized,
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

//MARK: ---- functions -----
//extension OTPView{
//    
//    func SendOtp() {
//        viewModel.mobile = phone
//        
//        viewModel.SendOtp{state in
////            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            switch state {
//            case .loading: break
////                Hud.showHud(in: self.view)
//            case .stopLoading: break
////                Hud.dismiss(from: self.view)
//            case .success:
////                Hud.dismiss(from: self.view)
//                print(state)
//
//                clearOtp()
//                   let seconds = viewModel.responseModel?.secondsCount ?? 60
//                   otp = viewModel.responseModel?.otp ?? 00
//                   startTimer(seconds: seconds)
//                
//            case .error(let code,let error):
////                Hud.dismiss(from: self.view)
////                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion:{
////                    if code == 400 {
////                        self.navigationController?.popViewController(animated: true)
////                    }
////                })
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    
//    func VerifyOtp() {
//        viewModel.mobile = phone
//        
////        guard let otp1 = TFIndex1.text ,let otp2 = TFIndex2.text,let otp3 = TFIndex3.text,let otp4 = TFIndex4.text,let otp5 = TFIndex5.text,let otp6 = TFIndex6.text else {return}
//        let fullotp = otpFields.joined()
//        viewModel.EnteredOtp = fullotp
//        viewModel.VerifyOtp(otpfor: verivyFor){ state in
////            guard let self = self else{return}
//            guard let state = state else{
//                return
//            }
//            switch state {
//            case .loading: break
//                //                Hud.showHud(in: self)
//            case .stopLoading: break
//                //                Hud.dismiss(from: self)
//            case .success:
//                //                Hud.dismiss(from: self)
//                print(state)
//                switch verivyFor {
//                case .CreateAccount:
//                    // got to success creating account
//                    accountCreated()
//                case .forgetPassword:
//                    gotoResetPassword()
//                }
//            case .error(_,let error):
//                //                Hud.dismiss(from: self)
//                //                SimpleAlert.shared.showAlert(title:error ?? "",message:"", viewController: self,completion: {
//                //                    self.clearOtp()
//                //                })
//                print(error ?? "")
//            case .none:
//                print("")
//            }
//        }
//    }
//    
//    private func gotoResetPassword(){
//        guard let vc = initiateViewController(storyboardName: .main, viewControllerIdentifier: ForgetPasswordVC.self) else{return}
//        vc.Phonenumber = phone
//        pushUIKitVC(vc)
////        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func accountCreated()  {
////        if let viewDone:ViewDone = showView(fromNib: ViewDone.self, in: self) {
////            viewDone.title = "created_title"
////            viewDone.subtitle1 = "created_subtitle1"
////            viewDone.subtitle2 = "created_subtitle2"
////            viewDone.ButtonTitle = "created_btn"
////            
////            viewDone.imgStr = "successicon"
////            viewDone.action = {
////                viewDone.removeFromSuperview()
//////                self.navigationController?.popViewController(animated: true)
////                //                Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
////                let newHome = UIHostingController(rootView: LoginView())
////                Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
////                
////            }
//        }
//    
//    private func clearOtp(){
//        otpFields.removeAll()
//    }
//}




import SwiftUI

struct SuccessView: View {
    var image: Image
    var title: String
    var subtitle1: String
    var subtitle2: String
    var buttonTitle: String
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            image
//                .resizable()
//                .frame(width: 100, height: 100)
                .padding(.top)

            Text(title.localized)
                .font(.bold(size: 36))
                .foregroundColor(Color(.main))
                .multilineTextAlignment(.center)
//                .padding(.horizontal,10)

            Text(subtitle1.localized)
                .font(.medium(size: 18))
                .foregroundColor(Color(.secondary))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(subtitle2.localized)
                .font(.medium(size: 18))
                .foregroundColor(Color(.secondary))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            
            CustomButtonUI(title: buttonTitle.localized, isValid: true) {
                buttonAction?()
            }
        }
        .padding()
    }
}

#Preview{
    SuccessView(
        image: Image("successicon"),
        title: "created_title".localized,
        subtitle1: "created_subtitle1".localized,
        subtitle2: "created_subtitle2".localized,
        buttonTitle: "created_btn".localized,
        buttonAction: {
            // Navigate to home or login
        }
    )
}
