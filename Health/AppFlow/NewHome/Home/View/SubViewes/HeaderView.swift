//
//  HeaderView.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack{
                HStack{
                    Image(.logo)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                    
                    (Text("home_Welcome".localized)
                        .font(.medium(size: 24))

                     + Text(" \("بلال")"))
                        .font(.bold(size: 24))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack{
                    Text("home_subtitle1".localized)
                        .font(.semiBold(size: 18))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("home_subtitle2".localized)
                        .font(.medium(size: 14))
                        .foregroundStyle(Color(.secondaryMain))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,4)
                }
                .padding(.vertical)
            }
            
            Image(.sehatylogobg)
        }
    }
}
