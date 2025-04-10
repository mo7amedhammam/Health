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
            CustomNavBar(title: "lang_Title".localized,image: nil)
            
            Spacer()
            
            VStack(spacing:10){
                Image(.languageicon)
                
                Text("lang_Subtitle".localized)
                    .frame(maxWidth:.infinity)
                    .font(.regular(size: 14))
                    .foregroundStyle(Color(.wrong))
                    .padding(.top,40)
                    .padding(.bottom,15)

                CustomButton(title: "lang_Ar_Btn"){
//                    localizationManager.currentLanguage = "ar"
                    setLanguage("ar")

//                    LocalizationManager.shared.setLanguage("ar"){ success in
//                        if success {
//                            print("✅ Localization updated successfully")
//                        } else {
//                            print("❌ Failed to update localization")
//                        }
//                    }
                }
                    .frame(width:200)

                CustomButton(title: "lang_En_Btn",backgroundcolor: Color(.secondaryMain)){
                    setLanguage("en")

//                    localizationManager.currentLanguage = "en"
//                    LocalizationManager.shared.setLanguage("en"){ success in
//                        if success {
//                            print("✅ Localization updated successfully")
//                        } else {
//                            print("❌ Failed to update localization")
//                        }
//                    }
                }
                    .frame(width:200)
            }
            
            Spacer()

            CustomButton(title: "lang_Ok_Btn".localized,isdisabled: LocalizationManager.shared.currentLanguage?.isEmpty){
                let rootVC = UIHostingController(rootView: OnboardingView())
                rootVC.navigationController?.isNavigationBarHidden = true
                rootVC.navigationController?.toolbar.isHidden = true
                Helper.shared.changeRootVC(newroot: rootVC, transitionFrom: .fromRight)
            }
        }
        .localizeView()

    }
    
    private func setLanguage(_ language: String) {
         LocalizationManager.shared.setLanguage(language) {_ in
             // Option 1: Force immediate reload (works for most cases)
             DispatchQueue.main.async {
                 UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SelectLanguageView())
             }
         }
     }
}

#Preview {
    SelectLanguageView()
}


