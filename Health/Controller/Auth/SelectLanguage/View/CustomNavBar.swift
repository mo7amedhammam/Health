//
//  CustomNavBar.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/04/2025.
//


import SwiftUI
struct CustomNavBar: View {
    var title: String? = "Title"
    var image: ImageResource? = .init(LocalizationManager.shared.currentLanguage == "en" ? .backLeft : .backRight)
    var onTap: (() -> Void)?
    var body: some View {
        ZStack(alignment: .trailing){
            Text(title?.localized ?? "")
                .frame(maxWidth:.infinity)
                .font(.bold(size: 18))
                .foregroundStyle(Color.mainBlue)
            
            if let image = image {
                Button(action: {
                    onTap?()
                }, label: {
                    Image(image)
                })
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomNavBar()
}
