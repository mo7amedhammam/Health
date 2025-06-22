//
//  SelectLanguageView.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/04/2025.
//

import SwiftUI

struct SelectLanguageView : View {
    @StateObject var localizationManager = LocalizationManager.shared
    @StateObject private var lookupsVM = LookupsViewModel.shared
    @State private var selectedCountry:AppCountryM? = .init(id: 1, name: "Egypt", flag: "🇪🇬")
    @State private var selectedLanguage:LanguageM? = .init(id: 1, lang1: "Arabic", flag: "🇪🇬")

    var hasbackBtn:Bool = false
    var body: some View {
        VStack{
//            CustomNavBar(title: "lang_Title".localized,hasBackBtn:hasackBtn)
            TitleBar(title: "lang_Title",hasbackBtn: hasbackBtn)
            
            Spacer()
            
            VStack(spacing:10){
                Image(.languageicon)
                
                Text("lang_Subtitle".localized)
                    .frame(maxWidth:.infinity)
                    .font(.semiBold(size: 22))
                    .foregroundStyle(Color(.wrong))
                    .padding(.top,40)
                    .padding(.bottom,40)

//                CustomButton(title: "lang_Ar_Btn"){
////                    localizationManager.currentLanguage = "ar"
//                    setLanguage("ar")
//
////                    LocalizationManager.shared.setLanguage("ar"){ success in
////                        if success {
////                            print("✅ Localization updated successfully")
////                        } else {
////                            print("❌ Failed to update localization")
////                        }
////                    }
//                }
//                    .frame(width:200)
//
//                CustomButton(title: "lang_En_Btn",backgroundcolor: Color(.secondaryMain)){
//                    setLanguage("en")
//
////                    localizationManager.currentLanguage = "en"
////                    LocalizationManager.shared.setLanguage("en"){ success in
////                        if success {
////                            print("✅ Localization updated successfully")
////                        } else {
////                            print("❌ Failed to update localization")
////                        }
////                    }
//                }
//                    .frame(width:200)
                
                VStack(spacing:30){
                    CustomInputFieldUI(
                        title: "lang_Language_title",
                        placeholder: "lang_Language_subitle",
//                        placeholder: "",

                        text: .constant( ""),
                        isValid: true,
                        isDisabled: true,
                        trailingView: AnyView(
                            Menu {
                                ForEach(lookupsVM.languages ?? [],id: \.self) { language in
                                    
                                    Button(action: {
                                        selectedLanguage = language  // ✅ Trigger state update
                                        Task{
                                            setLanguage(language.lang1 ?? "ar")
                                        }
                                    }, label: {
                                        HStack{
//                                            Text(language.lang1 ?? "")
                                            
                                            KFImageLoader(url:URL(string:Constants.imagesURL + (language.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                                .frame(width: 30,height:17)
                                        }
                                    })
                                    
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                    
//                                    Image(.languageBook)
//                                        .resizable()
//                                        .frame(width: 23,height:20)
                                                                        
                                    KFImageLoader(url:URL(string:Constants.imagesURL + (selectedLanguage?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                        .frame(width: 30,height:17)
                                }
                            }
                        )
                    )
                    .keyboardType(.asciiCapableNumberPad)
                    .task {
                        await lookupsVM.getLanguages()
                        if let languages = lookupsVM.languages {
                            selectedLanguage = languages.first(where: { $0.lang1 == localizationManager.currentLanguage }) ?? languages.first
                        }
                    }
                    
                    CustomInputFieldUI(
                        title: "lang_Country_title",
                        placeholder: "lang_Country_subitle",
                        text: .constant(selectedCountry?.name ?? ""),
                        isValid: true,
                        isDisabled: true,
                        trailingView: AnyView(
                            Menu {
                                ForEach(lookupsVM.appCountries ?? [],id: \.self) { country in
                                    
                                    Button(action: {
                                        Task {
                                            await MainActor.run(){
                                                
                                                selectedCountry = country
                                                //                                        setLanguage("en")
                                                if let selectedCountryId = country.id {
                                                    Helper.shared.AppCountryId(Id: selectedCountryId)
                                                }
                                            }
                                        }
                                    }, label: {
                                        HStack{
                                            Text(country.name ?? "")
                                            
                                            KFImageLoader(url:URL(string:Constants.imagesURL + (country.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                                .frame(width: 30,height:17)
                                        }
                                    })
                                    
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                    
                                    KFImageLoader(url:URL(string:Constants.imagesURL + (selectedCountry?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                        .frame(width: 30,height:17)
                                    
                                    //                                Text(selectedCountry?.flag ?? "")
                                    //                                    .foregroundColor(.mainBlue)
                                    //                                    .font(.medium(size: 22))
                                }
                            }
                        )
                    )
                    .keyboardType(.asciiCapableNumberPad)
                    .task {
                        await lookupsVM.getAppCountries()
                        if let countries = lookupsVM.appCountries {
                            selectedCountry = countries.first(where: { $0.id == Helper.shared.AppCountryId() ?? 0 }) ?? countries.first
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            
            Spacer()

            CustomButton(title: "lang_Ok_Btn".localized,isdisabled: LocalizationManager.shared.currentLanguage?.isEmpty,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                let rootVC = UIHostingController(rootView: OnboardingView())
                rootVC.navigationController?.isNavigationBarHidden = true
                rootVC.navigationController?.toolbar.isHidden = true
                Helper.shared.changeRootVC(newroot: rootVC, transitionFrom: .fromRight)
                
//                Helper.shared.changeRootVC(newroot: HTBC.self, transitionFrom: .fromRight)

            }
            
            
        }
        .localizeView()

    }
    
    private func setLanguage(_ language: String) {
         LocalizationManager.shared.setLanguage(language) {_ in
             // Option 1: Force immediate reload (works for most cases)
//             DispatchQueue.main.async {
//                 UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SelectLanguageView())
//             }
         }
     }
}

#Preview {
    SelectLanguageView()
}


