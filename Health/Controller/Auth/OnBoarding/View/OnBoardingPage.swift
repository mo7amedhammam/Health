//
//  OnBoardingPage.swift
//  Sehaty
//
//  Created by mohamed hammam on 03/04/2025.
//


import SwiftUI

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    let buttontitle: String
    let buttonaction: ()-> Void

    var body: some View {
        VStack(spacing:-50) {
            Image(image)
                .resizable()
                .scaledToFit()
            
            VStack(spacing: 20){
                Text(title.localized)
                    .font(Font.bold(size: 30))
                    .multilineTextAlignment(.center)
//                    .padding(.top, 10)
                    .padding(.horizontal)
                    .foregroundStyle(Color(.mainBlue))
                    .lineSpacing(8)
                    .frame(maxHeight: .infinity)
                
                Text(description.localized)
                    .font(Font.regular(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundStyle(Color(.wrong))
                    .lineSpacing(4)
               
                Spacer()
                
                Button(action: {
                    buttonaction()
                }, label: {
                    Text(buttontitle.localized)
                        .font(Font.bold(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.white))
                    
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color(.mainBlue))
                        .cornerRadius(3)
                        .padding(.horizontal,13)
                })
               
//                .padding(.bottom,10)
            }
            .padding(.top,25)
            .padding(.bottom,13)
            .frame(height:280)
            .cardStyle(cornerRadius: 12)
            .padding(.horizontal,33)
            
            Spacer()
        }
//        .padding()
        .edgesIgnoringSafeArea([.top,.horizontal])
    }
}

#Preview {
    OnboardingPage(image: "onboarding1", title: "مرحبًا بك في\n صحتي مع الندى!", description: "استشارات مع خبراء تغذية\n لمساعدتك على تحقيق أهدافك.", buttontitle: "التالي", buttonaction: {})
}
