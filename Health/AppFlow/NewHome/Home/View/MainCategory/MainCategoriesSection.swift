//
//  MainCategoriesSection.swift
//  Sehaty
//
//  Created by mohamed hammam on 04/07/2025.
//

import SwiftUI

struct MainCategoriesSection: View {
    var categories: HomeCategoryM?
    var action: ((HomeCategoryItemM) -> Void)?
    
    var body: some View {
        VStack(spacing:5){
            SectionHeader(image: Image(.newcategicon),title: "home_maincat"){
                //                            go to last mes package
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack(spacing:12){
                    let categories = categories?.items ?? []
                    
                    ForEach(categories, id: \.self) { item in
                        Button(action: {
                            action?(item)
                        }, label: {
                            ZStack(alignment: .bottom){
                                //                                Image(.onboarding2)
                                //                                    .resizable()
                                //                                    .frame(width: 166, height: 221)
                                
//                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"),placeholderSize: CGSize(width: 166, height: 221), shouldRefetch: true)
                                KFImageLoader(url:URL(string:Constants.imagesURL + (item.homeImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)

                                    .frame(width: 166, height: 221)
                                
                                VStack(alignment: .leading){
                                    Text(item.title ?? "")
                                        .font(.semiBold(size: 18))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    
                                    HStack{
                                        HStack(spacing:2){
                                            Image(.newsubmaincaticon)
                                                .resizable()
                                                .frame(width: 9,height:9)
                                                .scaledToFit()
                                            
                                            ( Text(" \(item.subCategoryCount ?? 0) ") + Text("sub_category".localized))
                                                .font(.medium(size: 12))
                                            
                                        }
                                        .foregroundStyle(Color.white)
                                        
                                        Spacer()
                                        
                                        HStack(spacing:2){
                                            
                                            Image("newvippackicon")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 8,height:9)
                                                .scaledToFit()
                                                .foregroundStyle(.white)
                                            
                                            ( Text(" \(item.packageCount ?? 0) ") + Text("package_".localized))
                                                .font(.medium(size: 12))
                                        }
                                        .foregroundStyle(Color.white)
                                    }
                                }
                                .padding([.vertical,.horizontal],10)
                                .background{
                                    BlurView(radius: 5)
                                        .horizontalGradientBackground().opacity(0.89)
                                }
                            }
                        })
                        .buttonStyle(.plain)
                        .cardStyle(cornerRadius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,5)
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}
#Preview {
    MainCategoriesSection()
}
