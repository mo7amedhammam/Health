//
//  OnboardingView.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
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
            HStack(alignment:.center) {
                ZStack{
                    if currentPage > 0 {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            Image(.previousLeft).flipsForRightToLeftLayoutDirection(true)
                        }
//                        .padding()
                    }
                }
                .frame(width: 50)

                Spacer()
                
                ForEach(0..<pages.count, id: \.self) { indx in
                        if indx == currentPage {
                            withAnimation{
                                Capsule().frame(width: 18,height: 5)
                                    .padding(0)
                                    .foregroundStyle(Color(.secondary))
                            }
                        }else{
                            Circle().frame(width: 5)
                                .padding(0)
                                .foregroundStyle(Color(.wrongsurface))
                        }
                }
                
                Spacer()

                Button(action: {
                    //'go home'
                    Helper.shared.onBoardOpened(opened: true)
                    SkipSplash()
                }) {
                    Text("bord_btn_skip".localized)
                        .font(.semiBold(size: 14))
                        .foregroundColor(.blue)
                }
//                .padding()

            }
            .frame(height: 50)
            .padding(.horizontal)

        }
        .localizeView()
        .edgesIgnoringSafeArea(.top)
    }
    
    func SkipSplash() {
//        Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromRight)

//        let newHome = UIHostingController(rootView: LoginView())
        let newHome = UIHostingController(rootView: NewTabView())
        Helper.shared.changeRootVC(newroot: newHome, transitionFrom: .fromLeft)
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
