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
        OnboardingPageData(image: "onboarding1", title: "مرحبًا بك في صحتي مع الندى!", description: "استشارات مع خبراء تغذية لمساعدتك على تحقيق أهدافك.", buttontitle: "التالي"),
        OnboardingPageData(image: "onboarding2", title: "تغذية صحية تناسب أهدافك!", description: "باقات مخصصة لتحسين نمط حياتك.", buttontitle: "التالي"),
        OnboardingPageData(image: "onboarding3", title: "تابع صحتك بسهولة!", description: "تتبع ضغط الدم، السكر، والهيموجلوبين بلمسة واحدة.", buttontitle: "التالي"),
        OnboardingPageData(image: "onboarding4", title: "لا تفوّت مواعيدك وأدويتك!", description: "تذكيرات ذكية للجرعات والمواعيد الطبية." ,buttontitle: "التالي"),
        OnboardingPageData(image: "onboarding5", title: "استشارات طبية وتغذوية متكاملة!", description: "خبراء لمساعدتك في قراراتك الصحية.", buttontitle: "ابدأ")
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
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                //'go home'
                                Helper.shared.onBoardOpened(opened: true)
                                SkipSplash()
                            }) {
                                Text("تخطي".localized)
                                    .font(.semiBold(size: 14))
                                    .foregroundColor(.blue)
                            }
                            .padding()

                            Spacer()

                            if index > 0 {
                                Button(action: {
                                    currentPage -= 1
                                }) {
                                    
                                    Image(LocalizationManager.shared.currentLanguage == "ar" ? .previousLeft : .previousRight)
                                }
                                .padding()
                            }
                            
                            
//                            if index == pages.count - 1 {
//                                Button(action: {
//                                    // Navigate to the main app
//                                }) {
//                                    Text("ابدأ")
//                                        .font(.headline)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.blue)
//                                        .foregroundColor(.white)
//                                        .cornerRadius(10)
//                                }
//                                .padding()
//                            } else {
//                                Button(action: {
//                                    currentPage += 1
//                                }) {
//                                    Text("التالي")
//                                        .foregroundColor(.blue)
//                                }
//                                .padding()
//                            }
                        }
                    }
                    .tag(index)
                }
            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            .padding()
//            .edgesIgnoringSafeArea(.top)
        }
//        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.top)
    }
    
    func SkipSplash() {
        Helper.shared.changeRootVC(newroot: LoginVC.self,transitionFrom: .fromLeft)
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
