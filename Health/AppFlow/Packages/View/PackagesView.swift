//
//  Packages.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct Packages: View {
    
    init() {
    }

    var body: some View {
//        NavigationView(){
        VStack(spacing:0){
                VStack(){
                    TitleBar(title: "",hasbackBtn: true)
                        .padding(.top,50)

                    Spacer()
                    
                    HStack{
                        VStack{
                            Text("pack_name")
                                .font(.bold(size: 18))
                                .foregroundStyle(.white)
                            
                            HStack(spacing:0){
                                Image(.newsubmaincaticon)
                                    .resizable()
                                    .frame(width: 11,height:11)
                                    .scaledToFit()
                                
                                ( Text(" 6 ") + Text("subcategory".localized))
                                    .font(.medium(size: 12))
                                
                            }
                            .foregroundStyle(Color.white)
                                
                        }
                        Spacer()
                        
                        VStack(){
                            Image("newvippackicon")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 13,height:15)
                                .scaledToFit()
                                .foregroundStyle(.white)
                            
                            ( Text(" 14 ") + Text("package".localized))
                                .font(.semiBold(size: 14))
                            
                        }
                        .foregroundStyle(Color.white)
                        
                    }
                    .padding(10)
                    .background{
                        BlurView(radius: 6)
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)

                    }
                    
                }
                .background{
                    Image(.adsbg2)
                        .resizable()
                }
                .frame(height: 195)
                
                
                ScrollView(showsIndicators: false){
                    
                    VStack(alignment:.leading){
                        
                        SubCategoriesSection()
                        
                        PackagesListView()
                        
                    }
                    .padding([.horizontal,.top],10)
                    
//                    Spacer()
                    
                    Spacer().frame(height: 55)
                }
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
    }
}

#Preview {
    Packages()
}

struct SubCategoriesSection: View {
    @State var selectedid = 0
    var body: some View {
        VStack(spacing:5){
            SectionHeader(image: Image(.newcategicon),title: "pack_subcat"){
                //                            go to last mes package
            }
            
            ScrollView(.horizontal,showsIndicators:false){
                HStack(spacing:12){
                    ForEach(0...7, id: \.self) { item in
                        Button(action: {
                            selectedid = item
                        }, label: {
//                            ZStack(){
//                                Image(.onboarding2)
//                                    .resizable()
//                                    .frame(width: 166, height: 221)

                            HStack(spacing:0){
                                                       
                                    Image(.packsubcat)
                                        .resizable()
                                        .frame(width: 48, height: 38)

                                    VStack(alignment: .leading){
                                        Text("اليوريك أسيد")
                                            .font(.semiBold(size: 14))
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity,alignment:.leading)
//                                            .minimumScaleFactor(0.5)
                                        
                                        Spacer()
                                        
                                        HStack{
                                            
                                            HStack(spacing:0){
                                                
                                                Image("newvippackicon")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 8,height:9)
                                                    .scaledToFit()
                                                    .foregroundStyle(.white)
                                                
                                                ( Text(" 14 ") + Text("package".localized))
                                                    .font(.medium(size: 8))
                                                    .frame(maxWidth: .infinity,alignment:.leading)

//                                                Spacer()
                                                
                                                Button(action:{
                                                }) {
                                                    
                                                    Image(systemName: "chevron.forward")
                                                        .foregroundStyle(Color.white)
                                                        .padding(4)
                                                        .font(.system(size: 8))
                                                        .background(Color.white.opacity(0.2).cornerRadius(1))
                                                }
                                                
                                            }
                                            .foregroundStyle(Color.white)
                                            
                                        }
                                        .padding(.leading,4)
                                        
                                    }
                                    .padding(.vertical,5)


                                }
                                .padding([.vertical,.horizontal],5)
//                                .padding(.horizontal,5)

                            //                                    .padding(.horizontal,5)

                                .frame(width: 140, height: 60)
                                .background{
                                    item == selectedid ? Color(.secondary) : Color(.btnDisabledTxt).opacity(0.5)
                                }

                                
//                                    .frame(width: 140, height: 60)

//                            }

                            
                        })
                        .cardStyle(cornerRadius: 6)
                        
                    }
                }
                
            }
            
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
        
    }
}


struct PackagesListView: View {
    var body: some View {
        VStack{
            SectionHeader(image: Image(.newvippackicon),title: "pack_packages"){
                //                            go to last mes package
            }
            
//            ScrollView(.horizontal,showsIndicators:false){
            ScrollView{
                    ForEach(0...7, id: \.self) { item in
                        Button(action: {
                            
                        }, label: {
                            ZStack(alignment: .bottom){
                                Image(.onboarding1)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                //                                    .frame(width: 166, height: 221)
                                    .frame( height: 180)
                                
                                VStack {
                                    HStack(alignment:.top){
                                        // Title
                                        HStack (spacing:3){
                                            Image(.newconversationicon)
                                                .resizable()
                                                .frame(width: 16, height: 9)
                                            Text("4 ").font(.semiBold(size: 16))
                                            
                                            Text("sessions".localized)
                                        }
                                        .font(.regular(size: 10))
                                        .foregroundStyle(Color.white)
                                        .frame(height:32)
                                        .padding(.horizontal,10)
                                        .background{Color(.secondaryMain)}
                                        .cardStyle( cornerRadius: 3)
                                        
                                        Spacer()
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(.newlikeicon)
                                                .resizable()
                                                .frame(width: 20, height: 20)

                                        })
                                        
                                    }
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                    .padding()
                                    
                                    Spacer()
                                    
                                    HStack(){
                                        VStack(alignment:.leading) {
                                            Text("pack_Name".localized)
                                                .font(.semiBold(size: 16))
                                                .foregroundStyle(Color.white)
//                                                .frame(maxWidth: .infinity,alignment:.leading)
                                            
                                            HStack(alignment: .center,spacing: 5){
                                                Image(.newdocicon)
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .frame(width: 8,height:9)
                                                        .scaledToFit()
                                                        .foregroundStyle(.white)
                                                        .padding(3)
                                                        .background(Color(.secondary))
                                                    
                                                    ( Text(" 35 ") + Text("avilable_doc".localized))
                                                        .font(.regular(size: 10))
                                                        .frame(maxWidth: .infinity,alignment:.leading)
                                            }
                                            .font(.regular(size: 10))
                                            .foregroundStyle(Color.white)
//                                            .frame(maxWidth: .infinity,alignment:.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading){
                                            Text("90 " + "EGP".localized)
                                                .font(.semiBold(size: 12))
                                                .foregroundStyle(Color.white)
                                            
                                            HStack{
                                                Text("140 " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                                                    .font(.semiBold(size: 12))
                                                
                                                (Text("(".localized + "Discount".localized ) + Text( " 20" + "%".localized + ")".localized))
                                                    .font(.semiBold(size: 12))
                                                    .foregroundStyle(Color.white)
                                            }
                                            .padding(.top,2)
                                        }
                                        
                                    }
                                    .padding(.top,5)
                                    .padding([.bottom,.horizontal],10)
                                    .background{
                                        BlurView(radius: 5)
                                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                                    }
                                }
                            }
                        })
                        .cardStyle(cornerRadius: 3)
//                        .frame(width: 200, height: 356)
                    }
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
    }
}
