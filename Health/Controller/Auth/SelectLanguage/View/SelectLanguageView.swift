//
//  SelectLanguageView.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/04/2025.
//

import SwiftUI

struct SelectLanguageView : View {
    @StateObject var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack{
            CustomNavBar(title: "اللغة",image: nil)
            
            Spacer()
            
            VStack(spacing:10){
                Image(.languageicon)
                
                Text("الرجاء اختيار اللغة".localized)
                    .frame(maxWidth:.infinity)
                    .font(.regular(size: 14))
                    .foregroundStyle(Color(.wrong))
                    .padding(.top,40)
                    .padding(.bottom,15)

                CustomButton(title: "العربية"){
                    localizationManager.currentLanguage = "ar"
                }
                    .frame(width:200)

                CustomButton(title: "الإنجليزية",backgroundcolor: Color(.secondaryMain)){
                    localizationManager.currentLanguage = "en"
                }
                    .frame(width:200)

            }
            
            Spacer()

            CustomButton(title: "تأكيد",isdisabled: localizationManager.currentLanguage == nil)
        }
        .localizeView()

    }
}

#Preview {
    SelectLanguageView()
}


