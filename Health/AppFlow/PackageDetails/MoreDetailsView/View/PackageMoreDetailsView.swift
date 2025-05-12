//
//  PackageMoreDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackageMoreDetailsView: View {
    
    init() {
    }

    var body: some View {
//        NavigationView(){
        VStack(spacing:0){
                VStack(){
                    TitleBar(title: "",hasbackBtn: true)
                        .padding(.top,50)

                    Spacer()
                    
//                    HStack{
                        VStack{
                            Text("doc".localized + "/".localized + "name")
                               .font(.bold(size: 16))
                                .foregroundStyle(.white)
                            
                            HStack(alignment: .center,spacing: 5){
                                Text( "التغذية العلاجية")
                                Circle().fill(Color(.white))
                                    .frame(width: 4, height: 4)
                                Text("صحة عامة")
                            }
                            .font(.medium(size: 10))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity,alignment:.center)
                            
                            HStack(spacing:2) {
                                Image(.newpharmacisticon)
//                                            .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 12,height:12)
                                    .scaledToFit()
//                                            .foregroundStyle(.white)
                                    .padding(3)
                                
                                Text("speciality")
                                   .font(.medium(size: 10))
                                   .foregroundStyle(Color.white)
                                
                            }
                            
//                            HStack(spacing:0){
//                                Image(.newsubmaincaticon)
//                                    .resizable()
//                                    .frame(width: 11,height:11)
//                                    .scaledToFit()
//                                
//                                ( Text(" 6 ") + Text("subcategory".localized))
//                                    .font(.medium(size: 12))
//                                
//                            }
//                            .foregroundStyle(Color.white)
                                
                        }
//                        Spacer()
                        
//                        VStack(){
//                            Image("newvippackicon")
//                                .renderingMode(.template)
//                                .resizable()
//                                .frame(width: 13,height:15)
//                                .scaledToFit()
//                                .foregroundStyle(.white)
//                            
//                            ( Text(" 14 ") + Text("package".localized))
//                                .font(.semiBold(size: 14))
//                            
//                        }
//                        .foregroundStyle(Color.white)
                        
//                    }
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
                        
                    HStack(alignment: .bottom){
                        
                        
                        VStack(alignment:.leading,spacing: 8){
                            Text("pack_Name".localized + ":")
                                .font(.regular(size: 13))
                                .foregroundStyle(Color.white)

                                Text("باقة الصحة العامة".localized + ":")
                                   .font(.semiBold(size: 15))
                                    .foregroundStyle(.white)
                                
                                HStack(alignment: .center,spacing: 5){
                                    Text( "التغذية العلاجية")
                                    Circle().fill(Color(.white))
                                        .frame(width: 4, height: 4)
                                    Text("صحة عامة")
                                }
                                .font(.medium(size: 10))
                                .foregroundStyle(Color.white)
                                

                                
    //                            HStack(spacing:0){
    //                                Image(.newsubmaincaticon)
    //                                    .resizable()
    //                                    .frame(width: 11,height:11)
    //                                    .scaledToFit()
    //
    //                                ( Text(" 6 ") + Text("subcategory".localized))
    //                                    .font(.medium(size: 12))
    //
    //                            }
    //                            .foregroundStyle(Color.white)
                                
                            
//                            Spacer()

                            // Title
                            HStack (spacing:0){
                                Image(.newconversationicon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 16, height: 9)
                                    .foregroundStyle(Color(.secondaryMain))

                               ( Text(" 4 " )
                                    .font(.semiBold(size: 16)) + Text( "sessions".localized)
                                    .font(.regular(size: 10)))
                                
                                Text(" - " + "sessions_Duration".localized)
                                    .font(.regular(size: 10))

                                Text(" 30 " + "Minute_".localized)
                                    .font(.regular(size: 10))
                                
                            }
//                            .font(.regular(size: 10))
                            .foregroundStyle(Color.white)
//                            .frame(height:32)
//                            .padding(.horizontal,10)
//                            .background{Color(.secondaryMain)}
//                            .cardStyle( cornerRadius: 3)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center,spacing: 4){
                            Group{
                                Text("90 " )
                                Text( "EGP".localized)
                            }
                                .font(.semiBold(size: 16))
                                .foregroundStyle(Color.white)
                            
//                            HStack{
                                Text("140 " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                                    .font(.semiBold(size: 12))
                                
                                (Text("(".localized + "Discount".localized ) + Text( " 20" + "%".localized + ")".localized))
                                    .font(.semiBold(size: 12))
                                    .foregroundStyle(Color.white)
//                            }
//                            .padding(.top,2)
                        }

                    }
//                    .offset(y:-12)
                    .padding()
                    .frame(height: 101)
                    .background(Color.mainBlue)
                    .cardStyle( cornerRadius: 3)

                        
                        
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
    PackageMoreDetailsView()
}


//struct AvailableDoctorsListView: View {
//    var body: some View {
//        VStack{
//            
//            SectionHeader(image: Image(.newdocicon),title: "\("22") \("available_doc".localized)"){
//                //                            go to last mes package
//            }
//            
////            ScrollView(.horizontal,showsIndicators:false){
//            ScrollView{
//                    ForEach(0...7, id: \.self) { item in
//                        Button(action: {
//                            
//                        }, label: {
//                            VStack{
//                                    Image(.onboarding1)
//                                        .resizable()
//                                        .frame( height: 160)
//                                        .aspectRatio(contentMode: .fill)
//                                        .cardStyle(cornerRadius: 3)
//                                
//                                
//                                HStack(alignment: .center,spacing: 5){
//                                    Text("doc".localized + "/".localized + "name")
//                                       .font(.bold(size: 16))
//                                       .frame(maxWidth: .infinity,alignment:.leading)
//                                       .foregroundStyle(Color.mainBlue)
//
//                                    HStack {
//                                        Text("doc".localized + "/".localized + "name")
//                                           .font(.medium(size: 10))
////                                           .frame(maxWidth: .infinity,alignment:.leading)
//                                           .foregroundStyle(Color.mainBlue)
//                                        
//                                        Image(.newpharmacisticon)
////                                            .renderingMode(.template)
//                                            .resizable()
//                                            .frame(width: 12,height:12)
//                                            .scaledToFit()
////                                            .foregroundStyle(.white)
//                                            .padding(3)
//                                    }
////                                        .background(Color(.secondary))
//                                    
//                                }
//                                Text("job title" + " - " + "uiniverrsity name")
//                                   .font(.medium(size: 10))
//                                   .frame(maxWidth: .infinity,alignment:.leading)
//                                   .foregroundStyle(Color(.secondary))
//                                   .padding(.bottom,2)
//                                
//                                Button(action: {
//                                    
//                                }){
//                                    HStack (spacing:5){
//                                        Image(.newmoreicon)
//                                            .renderingMode(.template)
//                                            .resizable()
//                                            .frame(width: 15, height: 15)
//                                        
//                                        Text("مزيد من التفاصيل".localized)
//                                    }
//                                    .font(.bold(size: 12))
//                                    .foregroundStyle(Color.white)
//                                    .frame(height:36)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.horizontal,10)
//                                    .background{Color(.secondaryMain)}
////                                    .cardStyle( cornerRadius: 3)
//                                    .cornerRadius(3)
//                                }
//                            }
////                            .padding(10)
////                            .cardStyle(cornerRadius: 3)
////                            .background{Color.white}
//
//                            
//                        })
//
////                        .padding()
////                        .cardStyle(cornerRadius: 3)
////                        .frame(width: 200, height: 356)
//
////                        .padding(.vertical,10)
////                        .background{Color.red}
//                        .background{Color.white}
//                                    .padding(10)
//
//                        .cardStyle(cornerRadius: 3)
//
//                    }
//                    .padding(.top,10)
//                            .padding(.horizontal,10)
//
////                    .cardStyle(cornerRadius: 3)
//
//            }
//            .padding(.horizontal,-10)
//            .padding(.top,-10)
//
//        }
////        .padding(.vertical,5)
//        .padding(.bottom,5)
//    }
//}
