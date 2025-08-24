//
//  TitleBar.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//
import SwiftUI

struct TitleBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var title: String = ""
    var titlecolor: Color? 
    var hasbackBtn:Bool = false
    var onBack: (() -> Void)? = nil  // << Add this

    var rightImage: Image?
    var rightBtnAction: (() -> Void)?
    
    var body: some View {
        HStack {
            // Left Button
            if hasbackBtn {
                Button(action:{
                    if let onBack = onBack {
                                           onBack()
                                       } else {
                                           dismiss()
                                       }
                }) {
                    Image(.backLeft)
                        .resizable()
                        .flipsForRightToLeftLayoutDirection(true)

                    //                        .foregroundStyle(Color.mainBlue)
                    
                }
                .frame(width: 31,height: 31)
            } else {
                Spacer().frame(width: 31) // Reserve space if needed
            }
            
            // Title
            Text(title.localized)
                .font(.bold(size: 20))
                .foregroundStyle(titlecolor ?? .mainBlue)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Right Button
            if let rightImage {
                Button(action: rightBtnAction ?? {}) {
                    rightImage
                        .resizable()
                    //                        .foregroundStyle(Color.mainBlue)
                }
                .frame(width: 31,height: 31)
                
            } else {
                Spacer().frame(width: 31) // Reserve space if needed
            }
        }
        .padding(.horizontal)
//        .reversLocalizeView()
    }
}
