//
//  SectionHeader.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct SectionHeader: View {
    var image: Image?
    var imageForground: Color?
    var title: String = ""
    var subTitle: (any View)?

    var hasMoreBtn: Bool = true
    var MoreBtnimage: ImageResource? = .newmoreicon
    var MoreBtnAction: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            if let image = image{
                image
                    .renderingMode(imageForground != nil ? .template:.original)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .scaledToFill()
                    .foregroundStyle(imageForground ?? .white)
            }
            VStack{
                Text(title.localized)
                    .font(.bold(size: 22))
                    .foregroundStyle(Color(.mainBlue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical,4)
                
                if let subTitle = subTitle {
                    AnyView(subTitle)
                }
            }
            if let image = MoreBtnimage{
                Button(action: MoreBtnAction ?? {}){
                    
//                    Image(MoreBtnimage ?? .newmoreicon)
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 18, height: 18)
                }
            }
        }
    }
}
#Preview{
    SectionHeader( title: "welcome",MoreBtnimage: .newfilter)
}
