//
//  WelcomeView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/07/2025.
//


import SwiftUI

struct LoginSheetView: View {
//    var onLogin: (() -> Void)?
//    var onSignup: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("welcom_title_elnada".localized)
                .font(.bold(size: 28))
                .foregroundColor(.mainBlue)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text("welcom_subtitle_elnada".localized)
                .font(.regular(size: 16))
                .foregroundColor(Color(.secondary))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .lineLimit(2)
            
            Spacer()
            
            VStack(spacing: 12) {
                
                CustomButton(title: "login_title",backgroundcolor: Color(.mainBlue),backgroundView:nil){
                    let newHome = UIHostingController(rootView: LoginView(skipToSignUp: false))
                    Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
                }
                if Helper.shared.getSelectedUserType() == .Customer{
                    CustomButton(title: "Signup_title",backgroundcolor: Color(.secondary),backgroundView:nil){
                        let newHome = UIHostingController(rootView: LoginView(skipToSignUp: true))
                        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
                    }
                }
            }
            .padding(.horizontal)

            Spacer(minLength: 40)
        }
        .padding()
        .background(Color.white)
        .localizeView()
    }
}

#Preview {
    LoginSheetView()
}
