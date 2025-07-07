//
//  HeaderView.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var viewModel: EditProfileViewModel
@State private var isLogedin = Helper.shared.CheckIfLoggedIn()
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack{
                HStack{
                    if isLogedin{
                        KFImageLoader(url:URL(string:Constants.imagesURL + (viewModel.imageURL?.validateSlashs() ?? "")),placeholder: Image(.user), isOpenable: true,shouldRefetch: false)

//                            Image(systemName: "person.circle.fill")
//                            .resizable()
                            .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    }
//                    Image(.logo)
//                        .frame(width: 50, height: 50)
//                        .clipShape(Circle())
//                        .aspectRatio(contentMode: .fit)
                    
                    HStack(spacing: 0){
                        
                    Text("home_Welcome".localized)
                        .font(.semiBold(size: 24))
                        .foregroundStyle(Color.mainBlue)
//                        .frame(maxWidth: .infinity, alignment: .leading)

                        if isLogedin && (viewModel.Name.count > 0){
                            Text(" \(viewModel.Name)!")
                                .font(.bold(size: 24))
                                .foregroundStyle(Color.mainBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
                
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
