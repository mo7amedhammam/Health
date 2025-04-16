//
//  NewHomeView.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/04/2025.
//

import SwiftUI

struct NewHomeView: View {
    
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    
    init() {
     // Large Navigation Title
     UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.purple]
     // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(resource: .mainBlue)]
   }
    var body: some View {
        NavigationView(){
            ScrollView{
                HStack{
                    Image(.logo)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                    
                    (Text("home_Welcome".localized) + Text( "بلال"))
                        .font(.bold(size: 18))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                VStack{
                    Text("home_subtitle1".localized)
                        .font(.bold(size: 16))
                        .foregroundStyle(Color.mainBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("home_subtitle2".localized)
                        .font(.bold(size: 12))
                        .foregroundStyle(Color(.secondaryMain))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,4)
                }
                .padding(.vertical)
                
                
                
                VStack(alignment:.leading){
                    Text("home_lastMes".localized)
                        .font(.bold(size: 16))
                        .foregroundStyle(Color(.secondaryMain))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,4)
                    
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0...7, id: \.self) { item in
                            VStack{
                                Text("اليوريك أسيد")
                                    .font(.bold(size: 12))
                                    .foregroundStyle(Color.mainBlue)
                                    .frame(maxWidth: .infinity)
                                
                                Image(.sugarMeasurement1)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .aspectRatio(contentMode: .fit)
                                
                                Text("240")
                                    .font(.bold(size: 10))
                                    .foregroundStyle(Color(.secondaryMain))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical,1)
                                
                                (Text("mes_inDate".localized) .font(.bold(size: 7))
                                 + Text( "27/6/2022"))
                                .font(.semiBold(size: 7))
                                .foregroundStyle(Color.mainBlue)
                                .frame(maxWidth: .infinity)
                            }
                            .frame(width: UIScreen.main.bounds.width/4.7, height: 95)
                            .cardStyle(cornerRadius: 5,shadowOpacity:0.09)
                        }
                        
                    }
                    
                    HStack (alignment: .bottom){
                        Text("home_newadv".localized)
                            .font(.bold(size: 16))
                            .foregroundStyle(Color(.secondaryMain))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        
                        
                        Button(action: {
                            
                        }, label: {
                            Image(.moredots)
                        })
                    }
                    
                    ScrollView(.horizontal,showsIndicators:false){
                        HStack{
                            ForEach(0...7, id: \.self) { item in
                                Button(action: {
                                    
                                }, label: {
                                    ZStack(alignment: .bottom){
                                        Image(.onboarding1)
                                            .resizable()
                                            .frame(width: 160, height: 153)
                                        
                                        VStack(alignment: .leading){
                                            
                                            ( Text( "أمراض الجلد") + Text(".").font(.system(size: 20))
                                              + Text("23 / 7 / 2023"))
                                            .font(.semiBold(size: 7))
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity,alignment:.leading)
                                            
                                            Text("اليوريك أسيد")
                                                .font(.bold(size: 18))
                                                .foregroundStyle(Color.white)
                                                .frame(maxWidth: .infinity,alignment:.leading)
                                        }
                                        .padding([.bottom,.horizontal],5)
                                    }
                                    
                                })
                                .cardStyle(cornerRadius: 6)
                                
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal,3)

                    }
                    
 
                    HStack (alignment: .bottom){
                        Text("home_mostviewedadv".localized)
                            .font(.bold(size: 16))
                            .foregroundStyle(Color(.secondaryMain))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        
                        
                        Button(action: {
                            
                        }, label: {
                            Image(.moredots)
                        })
                    }
                    
                    ScrollView(.horizontal,showsIndicators:false){
                        HStack{
                            ForEach(0...7, id: \.self) { item in
                                Button(action: {
                                    
                                }, label: {
                                    ZStack(alignment: .bottom){
                                        Image(.onboarding1)
                                            .resizable()
                                            .frame(width: 160, height: 153)
                                        
                                        VStack(alignment: .leading){
                                            
                                            ( Text( "أمراض الجلد") + Text(".").font(.system(size: 20))
                                              + Text("23 / 7 / 2023"))
                                            .font(.semiBold(size: 7))
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity,alignment:.leading)
                                            
                                            Text("اليوريك أسيد")
                                                .font(.bold(size: 18))
                                                .foregroundStyle(Color.white)
                                                .frame(maxWidth: .infinity,alignment:.leading)
                                        }
                                        .padding([.bottom,.horizontal],5)
                                    }
                                    
                                })
                                .cardStyle(cornerRadius: 6)
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal,3)

                    }
                    
                }
                
                Spacer()
                
                Spacer().frame(height: 40)
                
            }
            
            .padding(.horizontal)
            .navigationTitle(
                Text("home_navtitle".localized)
                    .font(Font.bold(size: 18))
                    .foregroundColor(Color.mainBlue)
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
//    NewHomeView()
    NewTabView()

}

