//
//  OnboardingView.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 1
    
    let pages = [
        OnboardingPageData(image: "onboarding1", title: "bord1_tilte", description: "bord1_subtilte", buttontitle: "bord_btn_next"),
        OnboardingPageData(image: "onboarding2", title: "bord2_tilte", description: "bord2_subtilte", buttontitle: "bord_btn_next"),
        OnboardingPageData(image: "onboarding3", title: "bord3_tilte", description: "bord3_subtilte", buttontitle: "bord_btn_next"),
        OnboardingPageData(image: "onboarding4", title: "bord4_tilte", description: "bord4_subtilte" ,buttontitle: "bord_btn_next"),
        OnboardingPageData(image: "onboarding5", title: "bord5_tilte", description: "bord5_subtilte", buttontitle: "bord_btn_start")
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack {
                        OnboardingPage(image: pages[index].image, title: pages[index].title, description: pages[index].description, buttontitle: pages[index].buttontitle){
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            }else{
                                //'go home'
                                Helper.shared.onBoardOpened(opened: true)
                                SkipSplash()
                            }
                        }
//                        Spacer()
                        
                    }
                    .tag(index)
                }
            }
            HStack {
                Button(action: {
                    //'go home'
                    Helper.shared.onBoardOpened(opened: true)
                    SkipSplash()
                }) {
                    Text("bord_btn_skip".localized)
                        .font(.semiBold(size: 14))
                        .foregroundColor(.blue)
                }
                .padding()

                Spacer()

                if currentPage > 0 {
                    Button(action: {
                        currentPage -= 1
                    }) {
                        
                        Image(LocalizationManager.shared.currentLanguage == "ar" ?  .previousRight :  .previousLeft)
                    }
                    .padding()
                }
            }
            .padding(.top)

        }
        .localizeView()
        .edgesIgnoringSafeArea(.top)
    }
    
    func SkipSplash() {
        Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromRight)
    }
}

struct OnboardingPageData {
    let image: String
    let title: String
    let description: String
    let buttontitle: String
}

#Preview {
    OnboardingView()
}
