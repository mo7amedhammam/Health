//
//  CustomButton.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/04/2025.
//

import SwiftUI

struct CustomButton: View {
    var title: String = "تأكيد"
    var font:Font? = .bold(size: 18)
    var foregroundcolor: Color? = .white
    var backgroundcolor: Color? = Color.mainBlue
    var cornerRadius: CGFloat? = 5
    var isdisabled: Bool? = false
    var backgroundView: AnyView? = AnyView(Color.mainBlue)

    var onTap: (() -> Void)?
    var body: some View {
        
        Button(action:{
            onTap?()
        }, label: {
            Text(title.localized)
                .font(font)
                .foregroundStyle(isdisabled ?? false ? Color(.btnDisabledTxt) : foregroundcolor ?? .white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background{
                    if let backgroundView = backgroundView {
                        backgroundView
                    }else{
                        isdisabled ?? false ? Color(.btnDisabledBg) : backgroundcolor
                    }
                }
                .cornerRadius(cornerRadius ?? 5)
                .padding(.horizontal)
        })
        .disabled(isdisabled ?? false)
       
    }
}

#Preview {
    CustomButton( onTap: {})
}
